provider "aws" {
}

resource "aws_instance" "my_server" {
  ami                    = "ami-0d2a4a5d69e46ea0b"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.my_server.id]

  tags = {
    Name = "my_server"
  }
  depends_on = [aws_instance.my_server_database, aws_instance.my_server_web]
}


resource "aws_security_group" "my_server" {
  name = "server_security group"

  dynamic "ingress" {
    for_each = ["80", "433", "22"]
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
    Name = "server-security-group"
  }
}

resource "aws_instance" "my_server_database" {
  ami                    = "ami-0d2a4a5d69e46ea0b"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.my_server.id]

  tags = {
    Name = "my_server"
  }
}

resource "aws_instance" "my_server_web" {
  ami                    = "ami-0d2a4a5d69e46ea0b"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.my_server.id]

  tags = {
    Name = "my_server"
  }
  depends_on = [aws_instance.my_server_database]
}
