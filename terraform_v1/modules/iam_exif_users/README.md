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
| [aws_iam_access_key.exif_s3_rob](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_access_key) | resource |
| [aws_iam_access_key.exif_s3_rwa](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_access_key) | resource |
| [aws_iam_user.exif_s3_rob](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user) | resource |
| [aws_iam_user.exif_s3_rwa](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user) | resource |
| [aws_iam_user_policy.exif_s3_rob](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user_policy) | resource |
| [aws_iam_user_policy.exif_s3_rwa](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user_policy) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_bucket_dest"></a> [bucket\_dest](#input\_bucket\_dest) | Exif-ripper destination bucket that sanitised files are copied to | `string` | n/a | yes |
| <a name="input_bucket_source"></a> [bucket\_source](#input\_bucket\_source) | Exif-ripper source bucket that is monitored for new files | `string` | n/a | yes |
| <a name="input_env"></a> [env](#input\_env) | Deployment environment. e.g. dev, uat, prod | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A map that is used to apply tags to resources created by terraform | `map(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_iam_exif_s3_rob_id"></a> [iam\_exif\_s3\_rob\_id](#output\_iam\_exif\_s3\_rob\_id) | user B RO IAM access id |
| <a name="output_iam_exif_s3_rob_secret"></a> [iam\_exif\_s3\_rob\_secret](#output\_iam\_exif\_s3\_rob\_secret) | user B RO IAM access secret |
| <a name="output_iam_exif_s3_rwa_id"></a> [iam\_exif\_s3\_rwa\_id](#output\_iam\_exif\_s3\_rwa\_id) | user A RW IAM access id |
| <a name="output_iam_exif_s3_rwa_secret"></a> [iam\_exif\_s3\_rwa\_secret](#output\_iam\_exif\_s3\_rwa\_secret) | user A RW IAM access secret |
<!-- END_TF_DOCS -->