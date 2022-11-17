
terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~>2.15.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}