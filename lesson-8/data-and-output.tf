provider "aws" {
}

data "aws_availability_zones" "working" {}
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}
output "zones" {
  value = data.aws_availability_zones.working.names[2]
}

output "identity" {
  value = data.aws_caller_identity.current.account_id
}

output "region_name" {
  value = data.aws_region.current.name
}
output "region_description" {
  value = data.aws_region.current.description
}
