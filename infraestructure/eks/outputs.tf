output "eks_cluster_name" {
  description = "Name of the EKS Cluster"
  value = aws_eks_cluster.eks_cluster.name
}

output "eks_cluster_arn" {
  description = "ARN of the EKS Cluster"  
  value = aws_eks_cluster.eks_cluster.arn
}