resource "aws_db_instance" "primary" {
  identifier                = "example-primary"
  snapshot_identifier       = "snapshot id"
  instance_class            = "db.t3.micro"
  vpc_security_group_ids    = ["sg-id"]
  skip_final_snapshot       = true
  final_snapshot_identifier = "snapshot"
  parameter_group_name      = "example-rds-name"
  publicly_accessible       = true
  timeouts {
    create = "0.5h"
  }
}