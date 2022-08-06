provider "aws" {}

resource "aws_instance" "server" {
  ami = data.aws_ami.latest_ubuntu.id
  //instance_type = var.env == "prod" ? "t3.micro" : "t2.micro"
  instance_type = var.env == "prod" ? var.ec2_size["prod"] : var.ec2_size["dev"]

  tags = {
    Name  = "${var.env}-server"
    Owner = var.env == "prod" ? var.prod_owner : var.noprod_owner
  }
}

resource "aws_instance" "dev_server" {
  ami           = data.aws_ami.latest_ubuntu.id
  instance_type = lookup(var.ec2_size, var.env)

  tags = {
    Name  = "${var.env}-server"
    Owner = var.env == "prod" ? var.prod_owner : var.noprod_owner
  }
}

resource "aws_instance" "Bastion-server" {
  count         = var.env == "dev" ? 1 : 0
  ami           = data.aws_ami.latest_ubuntu.id
  instance_type = "t2.micro"

  tags = {
    Name = "Bastion-server"
  }
}

resource "aws_security_group" "my_webserver" {
  name = "dynamic_security group"

  dynamic "ingress" {
    for_each = lookup(var.ports_list, var.env)
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
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
