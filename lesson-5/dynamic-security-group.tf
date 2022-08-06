#----------------------------------------------------
#MY WEBSITE ON TERRAFORM
#----------------------------------------------------
provider "aws" {
}

resource "aws_security_group" "my_webserver" {
  name = "dynamic_security group"

  dynamic "ingress" {
    for_each = ["80", "443", "8080", "22", "3306"]
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
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
