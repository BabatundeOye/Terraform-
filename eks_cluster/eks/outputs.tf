#...eks/outputs.tf

output "cluster_name" {
  value = aws_eks_cluster.luit.name
}

output "cluster_endpoint" {
  value = aws_eks_cluster.luit.endpoint
}