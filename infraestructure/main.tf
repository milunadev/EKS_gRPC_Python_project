module "networking_eks" {
  source = "./Networking"
  project_name = var.project_name
  private_subnet_number = var.network_module["private_subnet_number"]
  public_subnet_number = var.network_module["public_subnet_number"]
  availability_zones = var.network_module["availability_zones"]
}

module "eks" {
  source = "./eks"
  project_name = var.project_name
  eks_cluster_subnet_ids = module.networking_eks.private_subnet_ids
  eks_node_group_subnet_ids = module.networking_eks.private_subnet_ids
  eks_cluster_version = var.eks_cluster_version
  instance_types = var.instance_types

  #CONFIGURACION DE VARIABLES CODEBUILD
  codebuild_source_location = var.codebuild_config["github_repo"] 
  codebuild_source_version = var.codebuild_config["github_branch"]
  github_token = var.codebuild_config["github_token"]
  

}