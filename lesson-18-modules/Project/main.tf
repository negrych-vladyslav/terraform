#-------------------------------------------------------------------------------
provider "aws" {}
#-------------------------------------------------------------------------------
module "vpc-default" {
  source = "../modules/aws_network"
}

module "vpc-dev" {
  source              = "../modules/aws_network"
  env                 = "development"
  vpc_cidr            = "10.100.0.0/16"
  public_subnet_cidr  = ["10.100.1.0/24", "10.100.2.0/24"]
  private_subnet_cidr = []
}

module "vpc-prod" {
  source              = "../modules/aws_network"
  env                 = "production"
  vpc_cidr            = "10.99.0.0/16"
  public_subnet_cidr  = ["10.99.1.0/24", "10.99.2.0/24"]
  private_subnet_cidr = ["10.99.11.0/24", "10.99.22.0/24"]
}
#-------------------------------------------------------------------------------
output "prod_public_subnets_ids" {
  value = module.vpc-prod.public_subnets_id
}

output "prod_private_subnets_ids" {
  value = module.vpc-prod.private_subnets_id
}

output "dev_private_subnets_ids" {
  value = module.vpc-dev.private_subnets_id
}
