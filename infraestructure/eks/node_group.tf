##################################################
#               CLUSTER NODE GROUP 
###################################################

resource "aws_eks_node_group" "node_group" {
    cluster_name    = aws_eks_cluster.eks_cluster.name
    node_group_name = "${var.project_name}_node_group"
    node_role_arn   = aws_iam_role.eks_node_role.arn
    subnet_ids      = var.eks_node_group_subnet_ids
    instance_types = var.instance_types

    scaling_config {
        desired_size = var.eks_node_scaling_config.desired_size
        max_size     = var.eks_node_scaling_config.max_size
        min_size     = var.eks_node_scaling_config.min_size
    }
    
    tags = {    
        Name = "${var.project_name}_node_group"
        deployedby = "terraform"
    }    

    depends_on = [ aws_iam_role.eks_node_role , aws_eks_cluster.eks_cluster ]   
}