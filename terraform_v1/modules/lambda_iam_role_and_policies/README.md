<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_role.lambda_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.test_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_bucket_dest"></a> [bucket\_dest](#input\_bucket\_dest) | Exif-ripper destination bucket that sanitised files are copied to | `string` | n/a | yes |
| <a name="input_bucket_source"></a> [bucket\_source](#input\_bucket\_source) | Exif-ripper source bucket that is monitored for new files | `string` | n/a | yes |
| <a name="input_env"></a> [env](#input\_env) | Deployment environment. e.g. dev, uat, prod | `string` | n/a | yes |
| <a name="input_ssm_root_prefix"></a> [ssm\_root\_prefix](#input\_ssm\_root\_prefix) | SSM root prefix used to construct the key path | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A map that is used to apply tags to resources created by terraform | `map(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_iam_role_arn"></a> [iam\_role\_arn](#output\_iam\_role\_arn) | Lambda IAM role arn used for serverless function |
<!-- END_TF_DOCS -->