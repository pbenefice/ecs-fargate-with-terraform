# Naming

Provide the map of tags to use.  

## Example ussage

```
module "naming" {
  source = "../../modules/naming"

  env      = var.env
  project  = "ecs-with-terraform"
  tf_stack = "main"
}

provider "aws" {
  region = local.region

  default_tags {
    tags = module.naming.tags
  }
}
```

<!-- BEGIN_TF_DOCS -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_env"></a> [env](#input\_env) | The env | `string` | n/a | yes |
| <a name="input_project"></a> [project](#input\_project) | The name of the project | `string` | n/a | yes |
| <a name="input_tf_stack"></a> [tf\_stack](#input\_tf\_stack) | The name of the terraform stack | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_tags"></a> [tags](#output\_tags) | Map of tags to use |
<!-- END_TF_DOCS -->
