variable "env" {
  default = "dev"
}

variable "prod_owner" {
  default = "Vladyslav"
}

variable "noprod_owner" {
  default = "Dyadya Vasya"
}

variable "ec2_size" {
  default = {
    "prod"   = "t3.micro"
    "dev"    = "t2.micro"
    "string" = "t3.large"
  }
}

variable "ports_list" {
  default = {
    "prod" = ["80", "443"]
    "dev"  = ["22", "80", "3306"]
  }
}

