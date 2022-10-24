# child module ---variables.tf

variable "region" {
  description = "my deployment region"
  type        = string
  default     = "us-west-2"
}

variable "ami_id" {
    description = "my AMI id"
    type = string
    default = "ami-0d593311db5abb72b"
}

variable "instance_type" {
    description = "my instance type"
    type = string
    default = "t2.micro"
}