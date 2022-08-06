#----------------------------------------------------
#MY WEBSITE ON TERRAFORM
#----------------------------------------------------
provider "aws" {
}

resource "aws_eip" "my_ip" {
  instance = aws_instance.webserver.id
}

resource "aws_instance" "webserver" {
  ami                    = "ami-0d2a4a5d69e46ea0b"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.my_webserver.id]
  user_data = templatefile("bash.sh.tpl", {
    f_name = "Negrych"
    l_name = "Vladyslav"
    names  = ["vasya", "kolya", "anton"]
  })

  tags = {
    Name = "webserver-terraform"
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "my_webserver" {
  name = "webserver_security group"

  dynamic "ingress" {
    for_each = ["80", "433"]
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
    Name = "webserver-security-group"
  }
}
