#-----------------------------------------------------------------------------
#Web server zero downtime green/blue deployment
#-----------------------------------------------------------------------------
provider "aws" {}

data "aws_availability_zones" "availability" {}

data "aws_ami" "latest_ubuntu" {
  owners      = ["099720109477"]
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}
#------------------------------------------------------------------------------
resource "aws_security_group" "my_security_group" {
  name = "my_security_group"

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
    Name = "my_security_group"
  }
}

resource "aws_launch_configuration" "web" {
  #  name            = "web"
  name_prefix     = "web-"
  image_id        = data.aws_ami.latest_ubuntu.id
  instance_type   = "t2.micro"
  security_groups = [aws_security_group.my_security_group.id]
  user_data       = file("user_data.sh")

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "web" {
  name                 = "web-${aws_launch_configuration.web.name}"
  launch_configuration = aws_launch_configuration.web.name
  min_size             = 2
  max_size             = 2
  min_elb_capacity     = 2
  vpc_zone_identifier  = [aws_default_subnet.default-az1.id, aws_default_subnet.default-az2.id]
  health_check_type    = "ELB"
  load_balancers       = [aws_elb.web.name]

  dynamic "tag" {
    for_each = {
      Name   = "WebServer"
      Owner  = "Vladislav"
      TAGKEY = "TAGVALUE"
    }
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }
}

resource "aws_elb" "web" {
  name               = "web"
  availability_zones = [data.aws_availability_zones.availability.names[0], data.aws_availability_zones.availability.names[1]]
  security_groups    = [aws_security_group.my_security_group.id]
  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }
  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/"
    interval            = 10
  }
  tags = {
    Name = "web"
  }
}

resource "aws_default_subnet" "default-az1" {
  availability_zone = data.aws_availability_zones.availability.names[0]
}

resource "aws_default_subnet" "default-az2" {
  availability_zone = data.aws_availability_zones.availability.names[1]
}
#-----------------------------------------------------------------------
output "dns_name_load_balancer" {
  value = aws_elb.web.dns_name
}
