
region = "sa-east-1"

network_module = {
  public_subnet_number = 2
  private_subnet_number = 2
  availability_zones = [ "sa-east-1a", "sa-east-1b", "sa-east-1c" ]
}

project_name = "milunaeksdemo"

codebuild_config = {
  github_repo = "https://github.com/milunadev/eks_assesment.git"
  github_branch = "main"
  github_token = ""
}
