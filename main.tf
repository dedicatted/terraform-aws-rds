data "aws_caller_identity" "current" {}
data "aws_availability_zones" "available" {}
provider "aws" {
  region = "us-east-1"
}
module "db" {
  source = "github.com/terraform-aws-modules/terraform-aws-rds"

  identifier = "example-rds"

  # All available versions: https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/CHAP_PostgreSQL.html#PostgreSQL.Concepts
  engine               = "postgres"
  engine_version       = "14"
  family               = "postgres14" # DB parameter group
  major_engine_version = "14"         # DB option group
  instance_class       = "db.t3.micro"

  allocated_storage     = 20
  max_allocated_storage = 100

  # NOTE: Do NOT use 'user' as the value for 'username' as it throws:
  # "Error creating DB Instance: InvalidParameterValue: MasterUsername
  # user cannot be used as it is a reserved word used by the engine"
  db_name  = "example"
  username = "example"
  port     = 5432

  multi_az               = false
  db_subnet_group_name   = "example"
  vpc_security_group_ids = ["sg-id"]

  maintenance_window              = "Mon:00:00-Mon:03:00"
  backup_window                   = "03:00-06:00"
  enabled_cloudwatch_logs_exports = ["postgresql", "upgrade"]
  create_cloudwatch_log_group     = true

  backup_retention_period = 1
  skip_final_snapshot     = true
  deletion_protection     = false

  performance_insights_enabled          = true
  performance_insights_retention_period = 7
  create_monitoring_role                = true
  monitoring_interval                   = 60
  monitoring_role_name                  = "example-monitoring-role-name"
  monitoring_role_use_name_prefix       = true
  monitoring_role_description           = "Description for monitoring role"

  parameters = [
    {
      name  = "autovacuum"
      value = 1
    },
    {
      name  = "client_encoding"
      value = "utf8"
    }
  ]

  db_option_group_tags = {
    "Sensitive" = "low"
  }
  db_parameter_group_tags = {
    "Sensitive" = "low"
  }
}


################################################################################
# RDS Automated Backups Replication Module
################################################################################

provider "aws" {
  alias  = "region2"
  region = "eu-central-1"
}

module "kms" {
  source      = "terraform-aws-modules/kms/aws"
  version     = "~> 1.0"
  description = "KMS key for cross region automated backups replication"

  # Aliases
  aliases                 = ["example-snapshot-key"]
  aliases_use_name_prefix = true

  key_owners = [data.aws_caller_identity.current.arn]


  providers = {
    aws = aws.region2
  }
}

module "db_automated_backups_replication" {
  source = "github.com/terraform-aws-modules/terraform-aws-rds/modules/db_instance_automated_backups_replication"

  source_db_instance_arn = module.db.db_instance_arn
  kms_key_arn            = module.kms.key_arn

  providers = {
    aws = aws.region2
  }
}