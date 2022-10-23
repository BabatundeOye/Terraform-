variable "region" {
  description = "my deployment region"
  type        = string
  default     = "us-west-2"
}

variable "ami_id" {
  description = "my AMI id"
  type        = string
  default     = "xxx"
}

variable "instance" {
  description = "this is my instance"
  type        = string
  default     = "t2.micro"
}

variable "db_username" {
  description = "database administrator name"
  type        = string
  sensitive   = true
}

variable "db_password" {
  description = "database administrator password"
  type        = string
  sensitive   = true
}


