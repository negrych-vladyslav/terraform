#----------------------------------------------------
#MY WEBSITE ON TERRAFORM
#----------------------------------------------------

provider "aws" {
}

resource "aws_instance" "webserver" {
  ami                    = "ami-0d2a4a5d69e46ea0b"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.my_webserver.id]
  user_data              = file("bash.sh")

  tags = {
    Name = "webserver-terraform"
  }
}

resource "aws_security_group" "my_webserver" {
  name        = "webserver_security group"
  description = "Allow TLS inbound traffic"

  ingress {
    description = "TLS from VPC"
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
    Name = "webserver-security-group"
  }
}
