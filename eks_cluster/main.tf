#root/main.tf


module "vpc" {
  source          = "./vpc"
  vpc_cidr        = local.vpc_cidr
  public_sn_count = 2
  # private_sn_count = 2
  max_subnets  = 8
  public_cidrs = [for i in range(1, 255, 2) : cidrsubnet("10.0.0.0/16", 8, i)]
  # private_cidrs    = [for i in range(2, 255, 2) : cidrsubnet("10.0.0.0/16", 8, i)]
  access_ip = "0.0.0.0/0"

}
module "eks" {
  source         = "./eks"
  vpc_id         = module.vpc.vpc_id
  public_subnets = module.vpc.public_subnets

}