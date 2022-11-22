#---vpc/outputs.tf
output "vpc_id" {
  value = aws_vpc.eks_vpc.id
}

output "public_subnets" {
  value = aws_subnet.eks_public_subnets.*.id
}

# output "private_subnet_ids" {
#   value = aws_subnet.eks_private_subnet.*.id
# }