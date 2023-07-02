# Genomics Test
**Step 1**
A company allows their users to upload pictures to an S3 bucket. These pictures are always in the .jpg format. The company wants these files to be stripped from any exif metadata before being shown on their website. Pictures are uploaded to an S3 bucket A. Create a system that retrieves .jpg files when they are uploaded to the S3 bucket A, removes any exif metadata, and save them to another S3 bucket B. The path of the files should be the same in buckets A and B.

![Brief](docs/image_structure.png)

**Step 2**
To extend this further, we have two users User A and User B. Create IAM users with the following access:
* User A can Read/Write to Bucket A
* User B can Read from Bucket B

## Solution Overview

![Exif-ripper architecture](docs/exif_ripper.drawio.png)

A natural solution for this problem is to use AWS lambda because this service provides the ability to monitor an s3 bucket and trigger event based messages that can be sent to any arbitrary downstream image processor. Indeed, a whole pipeline of lambda functions can used in the "chain of responsibility pattern" if desired.

![Chain of responsibility](docs/Chained-Microservices-Design-Pattern.png)

Given the limited time to accomplish this task, a benefit of using Serverless is that it is trivial to set up monitoring on a bucket for pushed images because the framework creates the monitoring lambda for us in a few lines of code. When the following code is added to the Serverless.yml file, the monitoring lambda pushes an [event](https://www.Serverless.com/framework/docs/providers/aws/events/s3) to the custom exif-ripper lambda when a file with the suffix of `.jpg` and a s3 key prefix of `incoming/` is created in the bucket called `mysource-bucket`.

```yaml
functions:
  exif:
    handler: exif.handler
    events:
      - s3:
          bucket: mysource-bucket
          event: s3:ObjectCreated:*
          rules:
            - prefix: uploads/
            - suffix: .jpg
```

The lambda Python3 code for exif-ripper is located in `Serverless/exif-ripper/` and it leverages the following libraries to execute the following workflow:
1. [boto3](https://boto3.amazonaws.com/v1/documentation/api/latest/reference/services/s3.html#s3): Read binary image file from s3 into RAM.
2. [exif](https://pypi.org/project/exif/): Strips any exif data from image
3. Use Boto3 again to write the sanitised file to the destination bucket.

### Deployment tool overview
The solution for this problem was solved using the following deployment tools:
1. Terraform - To create common shared resources such as IAM entities & policies, security groups, sqs queues, S3 buckets, databases, etc
2. Serverless (sls) - To deploy lambda functions - lambda functions, API Gateways, step functions, etc

Sls is a better choice to deploy app-specific infrastructure because the Serverless.yml is tightly coupled to the app code and thus changes can be easily made in a few lines of code compared to the several pages required for Terraform. Additionally, it allows developers to easily modify the infrastructure without asking for DevOps help (as not everyone knows the Terraform DSL). However, It can be a bad idea to allow anyone with access to a Serverless.yml file to deploy whatever they like. Thus, shared-infrastructure that is more stateful is deployed solely by Terraform and ideally this paradigm would be enforced by appropriate IAM permissions. Methods to pass & share data between the two frameworks include the following:

1. Using Terraform data
2. Reading remote terraform state
3. Writing and consuming variables from SSM
4. Using `terraform out` to write out output values to file
5. Using AWS CLI to retrieve data

Note that options 3 & 4 are used in this example repo.


Further reading:
1. [The definitive guide to using Terraform with the Serverless Framework](https://www.Serverless.com/blog/definitive-guide-terraform-Serverless/)
2. [Terraform & Serverless framework, a match made in heaven?](https://medium.com/contino-engineering/terraform-Serverless-framework-a-match-made-in-heaven-part-i-69af51155e00)
3. [A Beginner's Guide to Terraform and Serverless](https://blog.scottlogic.com/2020/01/21/beginners-terraform-Serverless.html)


### Serverless Function Overview
Exif-Ripper is a Serverless application that creates an event triggering lambda that monitors a source s3 bucket for the upload of jpg files. When this occurs, an AWS event invokes another (python3) lambda function that strips the exif data from the jpg and writes the "sanitised" jpg to a destination bucket. This lambda function also reads & processes the image directly in memory, and thus does not incur write time-penalties by writing the file to scratch.

#### The Serverless.yml does the following:
See `Serverless/exif-ripper/Serverless.yml`
1. Uses the Serverless deployment bucket created by Terraform
2. Fetches ssm variables that have previously been pushed by the Terraform code: (source and destination buckets)
3. Creates the trigger on the source bucket
4. Creates the lambda function (using buckets created by Terraform)

```
.
└── Serverless
    └── exif-ripper
        ├── config
        └── test_images
```


#### Co-located Monorepo Directory Structure
```
.
├── Serverless
│   └── exif-ripper
│       ├── config
│       └── test_images
├── Terraform_v1
│   ├── 01_sls_deployment_bucket
│   ├── 02_DEV
│   ├── 03_PROD
│   └── modules
│       ├── exif_ripper_buckets
│       ├── iam_exif_users
│       └── lambda_iam_role_and_policies
└── Terraform_v2
    ├── 00_setup_remote_s3_backend_dev
    ├── 00_setup_remote_s3_backend_prod
    ├── entrypoints
    │   ├── exifripper_buckets_and_iam_role
    │   └── sls_deployment_bucket
    ├── envs
    │   ├── dev
    │   └── prod
    └── modules
        └──exif_ripper_buckets
```

The directory structure in this project co-locates the infrastructure code with the dev code. An alternative method is accomplished via separation of the infrastructure code from the dev code into 2 repos:

1. genomics-test (conatins dev Serverless code)
2. genomics-test-infra (contains only terraform code)

**Pros and cons of co-location method:**
The primary benefit of co-location of the terraform code within a Serverless project is the ostensible ease of deploying the compressed Serverless zip file from a single directory. [ See ./xxx_pipeline_create.sh](./xxx_pipeline_create.sh). This makes sense in the context of this example project because there is a requirement to share an uncomplicated code base.

```
.
└── genomics-test
    ├── Serverless (code repo)
    ├── Terraform_v1 (terraform repo)
    └── Terraform_v2 (terraform repo)
```

However, if a build server was available, we can escape monorepo-centric notions imposed by the co-location method because commands can be run outside of the context/restrictions of a single monorepo/folder. e.g:

```bash
.
└── build_agent_dir
    ├── genomics-test  (code repo)
        ├── Serverless
        └── exif-ripper
            ├── config
            └── test_images


### Note infra repo is accessible at another location on the same build server
.
└── /opt/all_terraform_consumers
    └── genomics-test-infra (terraform repo)
         └── terraform_v1

```


There are several benefits in maintaining the infrastructure code in a separate repo:
1. Increased DevOps agility: Application code is subject to a lengthy build & test process during which an artifact is typically created before it can be deployed. If the Terraform code is tightly coupled to the app code via co-location, then even trivial IaC changes such as changing a tag will result in a long delay before (re)deployment can occur. This is almost always unacceptable.
2. Dev code repos generally have a more complicated git [branching strategy/structure](https://www.flagship.io/git-branching-strategies/). e.g. GitFlow typically has master, develop, feature, release and hotfix branches. Such complexity is usually unsuitable for terraform IaC which typically only requires master and feature branches because terraform IaC can be designed to consume remote modules. As each remote module inhabits it's own git repo, terraform consumers can be [pinned](https://www.terraform.io/language/modules/sources#selecting-a-revision) against any tagged commit in the modules's master branch; or even be pinned against another branch or indeed, any arbitrary commit hash.

### Terraform code structure Overview
A few patterns of organising and deploying Terraform code are illustrated in this repo's example code. This is a large topic and there is no "one" right answer as it depends on the needs and scale of your organisation.

1. Monolith or multi-repo pattern?
2. Local or remote state?
3. Local and/or remote modules?
4. Organisational IaC architecture that addresses separation of concerns & scalability. DRY code and flexibility invariably results in an increase in complexity; the balance of which depends on the company's needs.


##### [5 Common Terraform Patterns (Click embedded video below)](https://www.youtube.com/watch?v=wgzgVm7Sqlk)
[![Evolving Your Infrastructure with Terraform" TEXT](./docs/evolving_terraform_thumb.png)](https://www.youtube.com/watch?v=wgzgVm7Sqlk "5 Common Terraform Patterns")

Some of the pertinent questions with regards to how terraform code is structured are listed below, but a detailed discussion is beyond the scope of this document.

1. `terraform_v1` - [The simplest method](https://github.com/meatware/genomics_test/blob/master/xxx_pipeline_create.sh#L44-L47)
    - Uses a local state file so the terraform.tfstate file is saved to the local disk. In order to facilitate shared team editing, the state file is typically stored in git. This is a potential security concern as sensitive values can be exposed.
    - Once the DEV environment is created, it can be copied and pasted to create UAT & DEV environments. Only a few values such as env value (e.g. `dev --> uat`) will have to be changed in the new env. However, the resulting code duplication can result in env-variant configuration drift and uncaught errors.
    - Uses publicly available remote modules from the [Terraform registry])(https://registry.terraform.io/) for resources such as s3 to avoid reinventing the wheel.
    - Uses local modules that are nested in the root of `terraform_v1`. This is a step in the right direction, but any modules defined here cannot be reused for other Terraform consumers. Furthermore, there is no module versioning and changes to these modules will be applicable to DEV, UAT & PROD. We can work around this by checking out specific branches in CI/CD in an env-specific manner, but this is a clunky solution that has suboptimal visibility.
2. `terraform_v2` - [A DRY method](https://github.com/meatware/genomics_test/blob/master/xxx_tfver2_pipeline_create.sh#L73-L76)
    - Uses a remote s3/dynamodb backend with remote state locking. Facilitates multi-user collaboration
    - DRY: Leverages passing in tfvar variables (stored in the envs folder) via the `-var-file` CLI argument. e.g. `terraform init -backend-config=../../envs/${myenv}/${myenv}.backend.hcl`,  followed by `terraform apply -var-file=../../envs/${myenv}/${myenv}.tfvars` A disadvantage is complexity increase and potential accidental deployment to the wrong environment if deploying from the CLI. Usually not such a big problem because CI/CD is used to deploy. However, something to watch out for.
    - Uses custom remote module written by yours truly to provision an IAM role with custom or managed policies. The remote module is versioned with release  tags and can be found here: https://github.com/meatware/tfmod-iam-role-with-policies.


#### Terraform_v1 components & workflow
See `xxx_pipeline_create.sh`

1. Creates a global Serverless deployment bucket which can be used by multiple apps. Multiple Serverless projects can be nested in this bucket. This is to avoid the multiple random Serverless buckets being scattered around the root of s3.
2. Creates source & destination s3 buckets for exif image processing
3. Pushes the names of these buckets to SSM
4. Creates a lambda role and policy using a custom remote module pinned to a specific tag
5. Creates two users with RO and RW permissions to the buckets as specified in the brief
6. Uses `Terraform output` to write the role arn & the deployment bucket name to the Serverless folder. Both these variables are used to bootstrap Serverless and thus cannot be retrieved from SSM.

```
.
├── 01_sls_deployment_bucket
├── 02_DEV
├── 03_PROD
└── modules
    ├── exif_ripper_buckets
    ├── iam_exif_users
    └── lambda_iam_role_and_policies

```

#### Terraform_v2 does the following:
**(Please ensure any infra created by v1 is destroyed before deploying v2!)**
This version is included to illustrate a method that is more DRY than v1. See `xxx_tfver2_pipeline_create.sh`
1. Creates a global s3/dynamodb backend and writes the backend config files to envs folder (`00_setup_remote_s3_backend_{dev,prod}`)
2. Creates Serverless deployment bucket. Multiple Serverless projects can be nested in this bucket. This is to avoid the mess of multiple random Serverless buckets being scattered around the root of s3.
3. Creates source & destination s3 buckets for exif image processing
4. Pushes the names of these buckets to SSM
5. Creates a lambda role and policy using a [remote module](https://github.com/meatware/tfmod-iam-role-with-policies).
    - Uses tags so that consumers pin to a specific version of the upstream code
    - Has [scripts](https://github.com/meatware/tfmod-iam-role-with-policies/blob/master/xxx_terraform-docs.sh) to automate README.md creation
    - Has live examples that can be [created](https://github.com/meatware/tfmod-iam-role-with-policies/blob/master/xxx_tests_run_examples.sh) and [destroyed](https://github.com/meatware/tfmod-iam-role-with-policies/blob/master/xxx_tests_destroy_examples.sh) to test any new code that might be merged into master


```
.
├── 00_setup_remote_s3_backend_dev
├── 00_setup_remote_s3_backend_prod
├── entrypoints
│   ├── exifripper_buckets_and_iam_role
│   └── sls_deployment_bucket
├── envs
│   ├── dev
│   └── prod
└── modules
    └── exif_ripper_buckets
```




## Deployment notes
As s3 buckets must be unique, a random string is used so that multiple people can run the deployment in their own environments at any given time without error.


## Practical Usage
**All instructions are for Ubuntu 20.04 using BASH in a terminal, so your mileage may vary if using a different system.
Several scripts have been included to assist getting this solution deployed. Please treat these scripts as additional documentation and give them a read.**

#### Install NVM, Node & Serverless

```bash
cd ~/Downloads
sudo apt install curl
curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash
source ~/.profile
nvm install 14
npm install -g Serverless
cd -
```

#### Please ensure you have exported your aws credentials into your shell
This has been test-deployed into an R&D account using Admin credentials. Try to do the same or use an account with the perms to use lambda, s3, iam, dynamodb, and SSM (systems manager) at the least.

An optional method to get a great bash experience via https://github.com/meatware/sys_bashrc

```bash
cd
git clone https://github.com/meatware/sys_bashrc.git
mv .bashrc .your_old_bashrc
ln -fs ~/sys_bashrc/_bashrc ~/.bashrc
source ~/.bashrc
```

#### use awskeys command to easily export aws key as env variables with sys_bashrc

```bash
csp1
colsw 72
awskeys help
awskeys list
awskeys export $YOUR_AWS_PROFILE
```

#### Running Deploy Scripts

```bash
### Install packages
sudo apt install eog jq unzip curl wget

### Install latest aws cli
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

### Install terraform_1.0.6
wget https://releases.hashicorp.com/terraform/1.0.6/terraform_1.0.6_linux_amd64.zip
unzip terraform_1.0.6_linux_amd64.zip
sudo mv terraform /usr/local/bin/terraform_v1.0.6
rm -f terraform_1.0.6_linux_amd64.zip
```

#### Terraform_v1 with Serverless application and users (just dev)
```bash
### Create stack From repo root
./xxx_pipeline_create.sh terraform_v1.0.6 $YOUR_TERRAFORM_EXEC $RANDOM_STRING

### Test Serverless function
cd Serverless/exif-ripper
    ./00_test_upload_image_2_s3_source.sh default

    ### Note you can tail serverless logs using
    serverless logs -f exif -t
cd -

### Test user permissions
cd terraform_v1/02_DEV/
    ./000_extract_user_secrets_from_tfstate.sh
    cat ./append_these_perms_to_aws_credentials_file.secrets # <<! take contents of this and paste into ~/.aws/credentials file

    ### run user perm tests & check output
    ./001_test_user_bucket_access.sh
cd -

### DESTROY STACK ONCE FINISHED
./xxx_pipeline_destroy.sh $YOUR_TERRAFORM_EXEC
```

#### Terraform_v2 (NO Serverless or Users) - dev & prod
```bash
### Create stack From repo root
./xxx_tfver2_pipeline_create.sh $YOUR_TERRAFORM_EXEC $RANDOM_STRING

### Look around and check code!!

### DESTROY STACK ONCE FINISHED
./xxx_tfver2_pipeline_destroy.sh $YOUR_TERRAFORM_EXEC $RANDOM_STRING

### Note you will have to manually delete the remote state buckets!
```
