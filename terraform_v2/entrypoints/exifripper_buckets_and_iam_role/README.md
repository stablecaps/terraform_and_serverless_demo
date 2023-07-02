<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | = 1.0.6 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 4.9.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_exif_buckets"></a> [exif\_buckets](#module\_exif\_buckets) | ../../modules/exif_ripper_buckets | n/a |
| <a name="module_lambda_role_and_policies"></a> [lambda\_role\_and\_policies](#module\_lambda\_role\_and\_policies) | github.com/meatware/tfmod-iam-role-with-policies | v2.0.0 |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_env"></a> [env](#input\_env) | Deployment environment. e.g. dev, uat, prod | `string` | n/a | yes |
| <a name="input_random_string"></a> [random\_string](#input\_random\_string) | A random string to ensure that different people can create uniuque s3 resources | `string` | n/a | yes |
| <a name="input_ssm_root_prefix"></a> [ssm\_root\_prefix](#input\_ssm\_root\_prefix) | SSM root prefix used to construct the key path | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_bucket_dest_name"></a> [bucket\_dest\_name](#output\_bucket\_dest\_name) | exif-ripper s3 destination bucket name |
| <a name="output_bucket_source_name"></a> [bucket\_source\_name](#output\_bucket\_source\_name) | exif-ripper s3 source bucket name |
| <a name="output_iam_role_arn"></a> [iam\_role\_arn](#output\_iam\_role\_arn) | Lambda IAM role arn used for serverless function |
<!-- END_TF_DOCS -->