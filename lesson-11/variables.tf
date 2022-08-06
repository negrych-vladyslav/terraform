variable "region" {
  description = "Enter your region please"
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "ports" {
  type    = list(any)
  default = ["80", "22", "3306", "443"]
}

variable "tags" {
  type = map(any)
  default = {
    Project     = variable-lesson
    Owner       = vladislav
    Environment = "development"
  }
}
