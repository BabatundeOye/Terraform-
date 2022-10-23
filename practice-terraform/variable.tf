variable "region" {
  description = "region of deployment"
  type        = string
  default     = "us-west-2"
}

variable "vpc_id" {
  description = "my vpc id"
  type        = string
  default     = "xxxx"
}

variable "ami_id" {
  description = "my AMI id"
  type        = string
  default     = "xxxx"
}

variable "instance" {
  description = "my instance type"
  type        = string
  default     = "t2.micro"
}
