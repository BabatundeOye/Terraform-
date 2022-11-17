#...module/vpc....

resource "random_string" "random" {
  length  = 5
  special = false
  upper   = false
}

data "aws_availability_zones" "available" {} #data source for available AZs

resource "random_shuffle" "az_list" {
  input        = data.aws_availability_zones.available.names
  result_count = var.max_subnets
}

#  VPC
resource "aws_vpc" "eks_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "eks_vpc-${random_string.random.id}"
  }
  lifecycle {
    create_before_destroy = true
  }
}

#  Public Subnets
resource "aws_subnet" "eks_public_subnet" {
  count                   = var.public_sn_count
  vpc_id                  = aws_vpc.eks_vpc.id
  cidr_block              = var.public_cidrs[count.index]
  map_public_ip_on_launch = true
  availability_zone       = random_shuffle.az_list.result[count.index]

  tags = {
    Name = "eks_public_${count.index + 1}"
  }
}

#  Private Subnets
resource "aws_subnet" "eks_private_subnet" {
  count                   = var.private_sn_count
  vpc_id                  = aws_vpc.eks_vpc.id
  cidr_block              = var.private_cidrs[count.index]
  map_public_ip_on_launch = false
  availability_zone       = random_shuffle.az_list.result[count.index]

  tags = {
    Name = "eks_private_${count.index + 1}"
  }
}

#  Internet Gateway
resource "aws_internet_gateway" "eks_igw" {
  vpc_id = aws_vpc.eks_vpc.id

  tags = {
    Name = "eks_igw"
  }
}

#public route table
resource "aws_route_table" "eks_public_rt" {
  vpc_id = aws_vpc.eks_vpc.id

  tags = {
    Name = "eks_public"
  }
}

#private route table
resource "aws_route_table" "eks_private_rt" {
  vpc_id = aws_vpc.eks_vpc.id

  tags = {
    Name = "eks_private"
  }
}

resource "aws_route_table_association" "eks_private_association" {
  count          = var.private_sn_count
  subnet_id      = aws_subnet.eks_private_subnet.*.id[count.index]
  route_table_id = aws_route_table.eks_private_rt.id
}

resource "aws_route_table_association" "eks_public_association" {
  count          = var.public_sn_count
  subnet_id      = aws_subnet.eks_public_subnet.*.id[count.index]
  route_table_id = aws_route_table.eks_public_rt.id
}