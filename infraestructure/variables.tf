
variable "region" {
  description = "Region donde se crearan todos los recursos de EKS"
}

variable "project_name" {
  description = "Nombre del proyecto para identificar los recursos de EKS en AWS"
}

variable "network_module" {
  description = "Variables para el modulo de red, incluye la lista de AZ y #s de subredes publicas y privadas"
  type = object({
    public_subnet_number  = number
    private_subnet_number = number
    availability_zones    = list(string)
  })
  default = {
    public_subnet_number  = 2
    private_subnet_number = 2
    availability_zones    = ["sa-east-1a", "sa-east-1b", "sa-east-1c"]
  }
}

variable "codebuild_config" {
  description = "Variables para el modulo de red, incluye la lista de AZ y #s de subredes publicas y privadas"
  type = object({
    github_repo = string
    github_branch = string
    github_token = string
  })
  default = {
    github_repo = "https://github.com/milunadev/eks_assesment.git"
    github_branch = "main"
    github_token = ""
  }
}

variable "eks_cluster_version" {
  default = "1.29"
}

variable "instance_types" {
  default = ["t3.medium"]
}