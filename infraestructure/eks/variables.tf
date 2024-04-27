variable "project_name" {
  
}

variable "eks_cluster_subnet_ids" {
  
}

variable "eks_node_group_subnet_ids"{

}

variable "eks_cluster_version" {
  default = "1.29"
}

variable "instance_types" {
  default = ["t3.medium"]
}

variable "eks_node_scaling_config" {
  description = "EKS node group scaling config"
  type = map(any)
  default = {
        desired_size = 1
        max_size     = 2
        min_size     = 1
    }
}

variable "codebuild_source_location" {
  description = "Codebuild source location repository"
}


variable "codebuild_source_version" {
  description = "Codebuild source location repository"
}

variable "eks_namespace" {
  default = "default"
}

variable "github_token" {
  
}