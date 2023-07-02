<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_s3_bucket_dest"></a> [s3\_bucket\_dest](#module\_s3\_bucket\_dest) | terraform-aws-modules/s3-bucket/aws | n/a |
| <a name="module_s3_bucket_source"></a> [s3\_bucket\_source](#module\_s3\_bucket\_source) | terraform-aws-modules/s3-bucket/aws | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_ssm_parameter.bucket_dest](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_ssm_parameter.bucket_source](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_bucket_dest"></a> [bucket\_dest](#input\_bucket\_dest) | Exif-ripper destination bucket that sanitised files are copied to | `string` | n/a | yes |
| <a name="input_bucket_source"></a> [bucket\_source](#input\_bucket\_source) | Exif-ripper source bucket that is monitored for new files | `string` | n/a | yes |
| <a name="input_env"></a> [env](#input\_env) | Deployment environment. e.g. dev, uat, prod | `string` | n/a | yes |
| <a name="input_random_string"></a> [random\_string](#input\_random\_string) | A random string to ensure that different people can create uniuque s3 resources | `string` | n/a | yes |
| <a name="input_ssm_root_prefix"></a> [ssm\_root\_prefix](#input\_ssm\_root\_prefix) | SSM root prefix used to construct the key path | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A map that is used to apply tags to resources created by terraform | `map(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_bucket_dest_name"></a> [bucket\_dest\_name](#output\_bucket\_dest\_name) | exif-ripper s3 destination bucket name |
| <a name="output_bucket_source_name"></a> [bucket\_source\_name](#output\_bucket\_source\_name) | exif-ripper s3 source bucket name |
<!-- END_TF_DOCS -->