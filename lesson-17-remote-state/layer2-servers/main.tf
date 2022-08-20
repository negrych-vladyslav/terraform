#-------------------------------------------------------------------------------
provider "aws" {}
#-------------------------------------------------------------------------------
terraform {
  backend "s3" {
    bucket = "vladyslav-negrich-project-x-terraform-state"
    key    = "dev/servers/terraform.tfstate"
    region = "eu-west-1"
  }
}
#-------------------------------------------------------------------------------
data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket = "vladyslav-negrich-project-x-terraform-state"
    key    = "dev/network/terraform.tfstate"
    region = "eu-west-1"
  }
}
#-------------------------------------------------------------------------------
resource "aws_security_group" "my_webserver" {
  name   = "dynamic_security group"
  vpc_id = data.terraform_remote_state.network.outputs.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [data.terraform_remote_state.network.outputs.vpc_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "dynamic-security-group"
  }
}
#-------------------------------------------------------------------------------
output "remote_state" {
  value = data.terraform_remote_state.network
}
