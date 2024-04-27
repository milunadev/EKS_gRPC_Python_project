resource "kubernetes_config_map_v1_data" "aws_auth" {
  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }

  data = {
    "mapRoles" = yamlencode([
      {
        "rolearn" : "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${aws_iam_role.eks_node_role.name}",
        "username" : "system:node:{{EC2PrivateDNSName}}",
        "groups" : [
          "system:bootstrappers",
          "system:nodes"
        ]
      },
      {
        "rolearn" : aws_iam_role.eks_codebuild_role.arn,
        "username" : "codebuild",
        "groups" : [
          "system:masters"
        ]
      }
    ])
  }

  force = true  # Use this carefully; it can overwrite other concurrent changes

  depends_on = [
    aws_eks_cluster.eks_cluster,
    aws_iam_role.eks_codebuild_role
  ]

}



resource "aws_iam_policy" "codebuild_policy" {
  name        = "${var.project_name}_CodeBuildIAMPolicy"
  description = "IAM policy for the CodeBuild project on EKS"
  policy      = templatefile("${path.module}/policies/iam_codebuild_policy.json.tpl", {
    ecr_repository_client_arn = aws_ecr_repository.eks_ecr_repository_client.arn,
    ecr_repository_server_arn = aws_ecr_repository.eks_ecr_repository.arn,
    eks_cluster_arn    = aws_eks_cluster.eks_cluster.arn
  })
}

resource "aws_iam_role" "eks_codebuild_role" {
  name = "${var.project_name}_codebuild_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "codebuild.amazonaws.com"
        }
      },
    ]
  })

  managed_policy_arns = [ aws_iam_policy.codebuild_policy.arn ]
}


resource "aws_codebuild_project" "ci_cd_eks" {
  name = "${var.project_name}_eks_codebuild"
  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image = "aws/codebuild/amazonlinux2-x86_64-standard:4.0"
    type = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    
    environment_variable {
      name = "EKS_CLUSTER_NAME"
      value = aws_eks_cluster.eks_cluster.name
    }
    environment_variable {
      name = "AWS_DEFAULT_REGION"
      value = "sa-east-1"
    }
    
  }

  source {
    type = "GITHUB"
    location = var.codebuild_source_location
    git_clone_depth = 2
    buildspec = "buildspec.yml"
    git_submodules_config {
      fetch_submodules = true
    }
    
  }
  source_version = var.codebuild_source_version

  artifacts {
    type = "NO_ARTIFACTS"
  }

  service_role = aws_iam_role.eks_codebuild_role.arn
  
}


resource "aws_codebuild_source_credential" "github" {
  auth_type  = "PERSONAL_ACCESS_TOKEN"
  server_type = "GITHUB"
  token       = var.github_token
}

resource "aws_codebuild_webhook" "example" {
  project_name = aws_codebuild_project.ci_cd_eks.name
  build_type   = "BUILD"
  filter_group {
    filter {
      type    = "EVENT"
      pattern = "PUSH"
    }
  }
}