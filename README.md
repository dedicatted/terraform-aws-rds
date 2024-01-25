# Complete RDS example for PostgreSQL

Configuration in this directory creates a set of RDS resources including DB instance, DB subnet group and DB parameter group.

## Usage

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example may create resources which cost money. Run `terraform destroy` when you don't need these resources.

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_db"></a> [db](#module\_db) | github.com/terraform-aws-modules/terraform-aws-rds | n/a |
| <a name="module_db_automated_backups_replication"></a> [db\_automated\_backups\_replication](#module\_db\_automated\_backups\_replication) | github.com/terraform-aws-modules/terraform-aws-rds/modules/db_instance_automated_backups_replication | n/a |
| <a name="module_kms"></a> [kms](#module\_kms) | terraform-aws-modules/kms/aws | ~> 1.0 |

## Resources

| Name | Type |
|------|------|
| [aws_availability_zones.available](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) | data source |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |

## Inputs

No inputs.

## Outputs

No outputs.
