#...main/eks

# EKS Cluster Resources
#  * IAM Role to allow EKS service to manage other AWS services
#  * IAM Role allowing EKS service manage other AWS services

#  * EKS Cluster

# IAM Role for EKS Cluster
resource "aws_iam_role" "luit-cluster" {
  name = "eks-cluster-luit-cluster"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "luit-cluster-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.luit-cluster.name
}

resource "aws_iam_role_policy_attachment" "luit-cluster-AmazonEKSVPCResourceController" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.luit-cluster.name
}

# Security Group to allow networking traffic with EKS cluster
resource "aws_security_group" "luit-cluster" {
  name        = "terraform-eks-luit-cluster"
  description = "Cluster communication with worker nodes"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "terraform-eks-luit"
  }
}



#EKS CLUSTER

resource "random_string" "random" {
  length  = 5
  special = false
  upper   = true
}

resource "aws_eks_cluster" "luit" {
  name     = "luit-${random_string.random.id}"
  role_arn = aws_iam_role.luit-cluster.arn

  vpc_config {
    security_group_ids = [aws_security_group.luit-cluster.id]
    subnet_ids         = var.public_subnets
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Cluster handling.
  # Otherwise, EKS will not be able to properly delete EKS managed EC2 infrastructure such as Security Groups.

  depends_on = [
    aws_iam_role_policy_attachment.luit-cluster-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.luit-cluster-AmazonEKSVPCResourceController,
  ]
}

