terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}


# Configure the AWS Provider
provider "aws" {
  region = "us-west-2"
}

resource "aws_instance" "app_server_web" {
  ami           = "xxxxx"
  instance_type = "t2.micro"
  user_data = file("build_apache.sh")
  tags = {
    Name = "HelloWorld"
  }
}