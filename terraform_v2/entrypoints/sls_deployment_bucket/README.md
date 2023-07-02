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
| <a name="module_s3_serverless_deployment_bucket"></a> [s3\_serverless\_deployment\_bucket](#module\_s3\_serverless\_deployment\_bucket) | terraform-aws-modules/s3-bucket/aws | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_env"></a> [env](#input\_env) | Deployment environment. e.g. dev, uat, prod | `string` | `"dev"` | no |
| <a name="input_random_string"></a> [random\_string](#input\_random\_string) | A random string to ensure that different people can create uniuque s3 resources | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_sls_deploy_bucket_name"></a> [sls\_deploy\_bucket\_name](#output\_sls\_deploy\_bucket\_name) | SLS deployment bucket name |
<!-- END_TF_DOCS -->