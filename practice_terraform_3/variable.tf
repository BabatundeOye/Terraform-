variable "region" {
  description = "my deployment region"
  type        = string
  default     = "us-west-2"
}

variable "ami_id" {
  description = "my AMI id"
  type        = string
  default     = "xxxxx"
}

variable "instance" {
  description = "this is my instance"
  type        = string
  default     = "t2.micro"
}

variable "s3_name" {
  description = "this is my s3"
  type        = string
  default     = "uniquebucket234678976"
}