terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.36.1"
    }
  }
}

provider "aws" {
  region = var.region
}

resource "aws_security_group" "security_group" {
  #Arguments
  name   = "ExampleWebSecurityGroup"
  vpc_id = var.vpc_id

  ingress {

    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }
}

resource "aws_instance" "web_server" {
  ami           = var.ami_id
  instance_type = var.instance

  tags = {
    Name = "my_web_server"
  }
}