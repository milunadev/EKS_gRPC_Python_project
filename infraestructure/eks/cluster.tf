##################################################
#               CLUSTER CONFIG
###################################################
resource "aws_eks_cluster" "eks_cluster" {
  name = "${var.project_name}_eks_cluster"
  role_arn = aws_iam_role.eks_cluster_role.arn
  version = var.eks_cluster_version
  vpc_config {
    subnet_ids = var.eks_cluster_subnet_ids  
    endpoint_private_access = true
    endpoint_public_access = true #####Debe ser cambiado a false para produccion
  }    
  
  tags = {
    Name = "${var.project_name}_eks_cluster"
    deployedby = "terraform"
  }
  
  depends_on = [ aws_iam_role.eks_cluster_role ]
}



##################################################
#               CLUSTER ADD-ONS 
###################################################

resource "aws_eks_addon" "cni-addon" {
  cluster_name = aws_eks_cluster.eks_cluster.name
  addon_name   = "vpc-cni"
}

resource "aws_eks_addon" "kube-proxy-addon" {
  cluster_name = aws_eks_cluster.eks_cluster.name
  addon_name   = "kube-proxy"
}

resource "aws_eks_addon" "coredns-addon" {
  cluster_name = aws_eks_cluster.eks_cluster.name
  addon_name   = "coredns"
}

