## Terraform Example

This is an example stack that deploys a PostgresSQL database instance, a Redis cluster, and tags that are attached to most of the AWS resources.

These are the Terraform modules we're using in this example:
- [terraform-aws-rds](https://github.com/downdetective/terraform-aws-rds)
- [terraform-aws-redis-replication-group](https://github.com/downdetective/terraform-aws-redis-replication-group)
- [terraform-aws-tags](https://github.com/downdetective/terraform-aws-tags)

More Terraform modules can be found in [TFCloud](https://app.terraform.io/app/downdetective-devops/registry/private/modules) or [GitHub](https://github.com/orgs/downdetective/repositories?language=&q=terraform-aws&sort=&type=all).

This Terraform stack is located in TFCloud under the workspace [devops-sample-app-dev](https://app.terraform.io/app/downdetective-devops/workspaces/devops-sample-app-dev).

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 4.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_rds"></a> [rds](#module\_rds) | app.terraform.io/downdetective-devops/rds/aws | 1.5.1 |
| <a name="module_redis-replication-group"></a> [redis-replication-group](#module\_redis-replication-group) | app.terraform.io/downdetective-devops/redis-replication-group/aws | 1.4.0 |
| <a name="module_tags"></a> [tags](#module\_tags) | app.terraform.io/downdetective-devops/tags/aws | 1.0.1 |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | n/a | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | n/a | `string` | `"development"` | no |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | n/a | `string` | n/a | yes |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | n/a | `list(string)` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | n/a | `string` | n/a | yes |

## Outputs

No outputs.
