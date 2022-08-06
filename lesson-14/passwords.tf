provider "aws" {}

variable "name" {
  default = "password"
}

resource "random_string" "rds_password" {
  length           = 8
  special          = true
  override_special = "#@!%"
  keepers = {
    name = var.name
  }
}

resource "aws_ssm_parameter" "rds_password" {
  name  = "/prod/mysql"
  type  = "SecureString"
  value = random_string.rds_password.result
}

data "aws_ssm_parameter" "rds_password" {
  name       = "/prod/mysql"
  depends_on = [aws_ssm_parameter.rds_password]
}

resource "aws_db_instance" "default" {
  identifier           = "prod-rds"
  allocated_storage    = 10
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t3.micro"
  name                 = "mydb"
  username             = "administrator"
  password             = data.aws_ssm_parameter.rds_password.value
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true
  apply_immediately    = true
}

output "rds_password" {
  value     = data.aws_ssm_parameter.rds_password.value
  sensitive = true
}
