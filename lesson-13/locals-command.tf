provider "aws" {}

data "aws_region" "current" {}

resource "null_resource" "command1" {
  provisioner "local-exec" {
    command = "echo Terraform start: $(date) >> log.txt"
  }
}

resource "null_resource" "command2" {
  provisioner "local-exec" {
    command = "ping -c 5 google.com"
  }
  depends_on = [null_resource.command1]
}

resource "null_resource" "command3" {
  provisioner "local-exec" {
    command     = "print('Hello World!')"
    interpreter = ["python3", "-c"]
  }
}

resource "null_resource" "command4" {
  provisioner "local-exec" {
    command = "echo $HOME1 $HOME2 $HOME3 >> name.txt"
    environment = {
      HOME1 = "VLAD"
      HOME2 = "IDU NAXUE"
      HOME3 = data.aws_region.current.name
    }
  }
}
