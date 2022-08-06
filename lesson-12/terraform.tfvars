region        = "eu-west-1"
instance_type = "t3.micro"
ports         = ["80", "443", "22", "3306", "8080"]
tags = {
  Project     = variable-lesson
  Environment = "development"
  Owner       = Vladyslav
}
