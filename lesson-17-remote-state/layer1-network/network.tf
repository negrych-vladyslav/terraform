provider "aws" {}
#-------------------------------------------------------------------------------
terraform {
  backend "s3" {
    bucket = "vladyslav-negrich-project-x-terraform-state"
    key    = "dev/network/terraform.tfstate"
    region = "eu-west-1"
  }
}

data "aws_availability_zones" "available" {}
#-------------------------------------------------------------------------------
variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "env" {
  default = "dev"
}

variable "public_subnet_cidr" {
  default = [
    "10.0.1.0/24",
    "10.0.2.0/24",
  ]
}
variable "availability_zones" {
  default = ["eu-west-a", "eu-west-b", "eu-west-c"]
}

#-------------------------------------------------------------------------------
resource "aws_vpc" "my_vpc" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "${var.env}-vpc"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.my_vpc.id
  tags = {
    Name = "${var.env}-igw"
  }
}
resource "aws_subnet" "public_subnets" {
  count                   = length(var.public_subnet_cidr)
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = element(var.public_subnet_cidr, count.index)
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.env}-public-${count.index + 1}"
  }
}
resource "aws_route_table" "public_subnets" {
  vpc_id = aws_vpc.my_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
  tags = {
    Name = "${var.env}-route-public-subnets"
  }
}
resource "aws_route_table_association" "public_routes" {
  count          = length(aws_subnet.public_subnets[*].id)
  route_table_id = aws_route_table.public_subnets.id
  subnet_id      = element(aws_subnet.public_subnets[*].id, count.index)
}
#-------------------------------------------------------------------------------
output "vpc_id" {
  value = aws_vpc.my_vpc.id
}

output "vpc_cidr" {
  value = aws_vpc.my_vpc.cidr_block
}

output "public_subnets_id" {
  value = aws_subnet.public_subnets[*].id
}
