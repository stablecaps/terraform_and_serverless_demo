<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.12.2 |
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | = 1.0.6 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 4.9.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_terraform_state_backend"></a> [terraform\_state\_backend](#module\_terraform\_state\_backend) | cloudposse/tfstate-backend/aws | 0.38.1 |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_env"></a> [env](#input\_env) | n/a | `string` | `"prod"` | no |
| <a name="input_random_string"></a> [random\_string](#input\_random\_string) | n/a | `string` | n/a | yes |
| <a name="input_terraform_backend_config_file_path"></a> [terraform\_backend\_config\_file\_path](#input\_terraform\_backend\_config\_file\_path) | n/a | `string` | `"."` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->