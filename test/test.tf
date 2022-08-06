provider "aws" {
}

resource "aws_instance" "test" {
  ami                    = "ami-0d2a4a5d69e46ea0b"
  instance_type          = "t2.micro"
  key_name               = "ssh1"
  vpc_security_group_ids = [aws_security_group.test.id]

 tags = {
    Owner = "test"
    Name = "test"
  }

}

resource "aws_security_group" "test" {
  name = "test"

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
 }
