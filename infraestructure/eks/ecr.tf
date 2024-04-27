resource "aws_ecr_repository" "eks_ecr_repository" {
  name                 = "${var.project_name}-server"
  image_tag_mutability = "MUTABLE"
}

resource "aws_ecr_repository" "eks_ecr_repository_client" {
  name                 = "${var.project_name}-client"
  image_tag_mutability = "MUTABLE"
}