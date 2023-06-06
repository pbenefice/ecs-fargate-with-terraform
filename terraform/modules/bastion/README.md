# bastion

Create EC2 instances in provided private subnet with access via SSM.  

## Example usage

```
data "aws_vpc" "selected" {
  filter {
    name   = "tag:project"
    values = ["ecs-fargate-with-terraform"]
  }

  filter {
    name   = "tag:env"
    values = [var.env]
  }
}

data "aws_subnets" "private_selected" {
  filter {
    name   = "tag:project"
    values = ["ecs-fargate-with-terraform"]
  }

  filter {
    name   = "tag:Name"
    values = ["*private*"]
  }

  filter {
    name   = "tag:env"
    values = [var.env]
  }
}

module "bastion" {
  source = "../../modules/bastion"

  name          = "bastion"
  env           = "dev"

  vpc_id        = data.aws_vpc.selected.id
  subnet_id     = data.aws_subnets.private_selected.ids[0]
  allowed_cidrs = [data.aws_vpc.selected.cidr_block]
}
```

Then use : `aws ssm start-session --target <ec2_instance_id>`  

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
| [aws_iam_instance_profile.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile) | resource |
| [aws_iam_role.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_instance.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |
| [aws_security_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_ami.latest_ubuntu](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |
| [aws_iam_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allowed_cidrs"></a> [allowed\_cidrs](#input\_allowed\_cidrs) | The CIDR to include in the security group attached to the created instances | `list(string)` | <pre>[<br>  "0.0.0.0/0"<br>]</pre> | no |
| <a name="input_env"></a> [env](#input\_env) | The env | `string` | n/a | yes |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | The instance type to use | `string` | `"t3.micro"` | no |
| <a name="input_name"></a> [name](#input\_name) | The name for the ami, used as prefix in conjonction with env | `string` | `"ec2_ssm"` | no |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | The CIDR to include in the security group attached to the created instances | `string` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The ID of the vpc to create the instance in | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_instance_id"></a> [instance\_id](#output\_instance\_id) | ID of the created instance |
<!-- END_TF_DOCS -->
