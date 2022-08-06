output "webserver_instance_id" {
  value = aws_instance.webserver.id
}

output "webserver_ip" {
  value = aws_eip.my_ip.public_ip
}

output "security_group_id" {
  value = aws_security_group.my_webserver.id
}

