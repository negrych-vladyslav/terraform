provider "aws" {}

data "aws_ami" "latest_ubuntu" {
  owners      = ["099720109477"]
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

resource "aws_instance" "test" {
  ami           = data.aws_ami.latest_ubuntu.id
  instance_type = "t2.micro"
  tags = {
    Name  = "test"
    Owner = "test"
  }
}
output "ubuntu_id" {
  value = data.aws_ami.latest_ubuntu.id
}

output "ubuntu_name" {
  value = data.aws_ami.latest_ubuntu.name
}
