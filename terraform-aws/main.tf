#-----root/main.tf

#Deploy Networking Resources

module "networking" {
  source   = "./networking"
  vpc_cidr = "10.123.0.0/16"
  #public_cidrs  = ["10.123.2.0/24", "10.123.4.0/24"] ---hardcodedd
  #private_cidrs = ["10.123.1.0/24", "10.123.3.0/24", "10.123.5.0/24"]----hardcoded
  private_sn_count = 3
  public_sn_count  = 2
  max_subnets = 20
  private_cidrs    = [for i in range(1, 255, 2) : cidrsubnet("10.123.0.0/16", 8, i)]
  public_cidrs     = [for i in range(2, 255, 2) : cidrsubnet("10.123.0.0/16", 8, i)]
}