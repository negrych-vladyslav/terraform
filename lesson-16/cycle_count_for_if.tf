provider "aws" {}

variable "users_list" {
  description = "List of IAM users to create"
  default     = ["vasya", "andrii", "petya", "nadya", "ira", "anton"]
}

resource "aws_iam_user" "users" {
  count = length(var.users_list)
  name  = element(var.users_list, count.index)
}

resource "aws_iam_user" "user1" {
  name = "pushkin"
}

output "created_iam_users_all" {
  value = aws_iam_user.users
}

output "created_iam_users_ids" {
  value = aws_iam_user.users[*].id
}

output "created_iam_users_custom" {
  value = [
    for user in aws_iam_user.users :
    "Hello user: ${user.name} for ARN: ${user.arn}"
  ]
}

output "created_iam_users_map" {
  value = {
    for user in aws_iam_user.users :
    user.unique_id => user.id # JAJD7420JFADJF : vasya
  }
}

output "custom_if_length" {
  value = [
    for x in aws_iam_user.users :
    x.name
    if length(x.name) == 5
  ]
}
#-------------------------------------------------------------------------------
resource "aws_instance" "servers" {
  count         = 3
  ami           = "ami-030802ad6e5ffb009"
  instance_type = "t2.micro"
  tags = {
    Name = "Server number ${count.index + 1}"
  }
}

output "server_all" {
  value = aws_instance.servers
}

output "server_map" {
  value = {
    for x in aws_instance.servers :
    x.id => x.public_ip
  }
}
