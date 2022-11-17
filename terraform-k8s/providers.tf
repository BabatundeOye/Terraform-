terraform {
  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "2.15.0"
    }
  }
}

provider "kubernetes" {
  # Configuration options
}