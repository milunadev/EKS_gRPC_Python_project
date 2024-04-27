##################################################
#               IAM EKS CLUSTER ROLE
###################################################

resource "aws_iam_role" "eks_cluster_role" {
  name = "${var.project_name}-eks-cluster-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "eks.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      },
    ]
  })

  managed_policy_arns = [ "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy", "arn:aws:iam::aws:policy/AmazonEKSServicePolicy" ]
}

##################################################
#               IAM EKS NODE ROLE
###################################################
resource "aws_iam_role" "eks_node_role" {
  name = "${var.project_name}-eks-node-role"

  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": "ec2.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
    ]
  })

  managed_policy_arns = [ "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy", "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy", "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly" ]
}

##################################################
#       IAM ROLE LOAD BALANCER CONTROLLER
###################################################

data "aws_caller_identity" "current" {}

resource "null_resource" "download_iam_policy" {
  provisioner "local-exec" {
    command = "curl -o ${path.module}/policies/iam_policy.json https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.7.2/docs/install/iam_policy.json"
  }

  triggers = {
    always_run = "${timestamp()}"
  }
}

data "local_file" "iam_policy" {
  filename = "${path.module}/policies/iam_policy.json"
  depends_on = [null_resource.download_iam_policy]
}

resource "aws_iam_policy" "alb_controller_policy" {
  name        = "${var.project_name}_ALBControllerIAMPolicy"
  description = "IAM policy for the ALB Ingress Controller on EKS"

  policy = data.local_file.iam_policy.content

}

resource "aws_iam_role" "alb_controller_role" {
  name = "${var.project_name}_ALBControllerRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Federated = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/${replace(aws_eks_cluster.eks_cluster.identity[0].oidc[0].issuer, "https://", "")}"
      },
      Action = "sts:AssumeRoleWithWebIdentity",
      Condition = {
        StringEquals = {
          "${replace(aws_eks_cluster.eks_cluster.identity[0].oidc[0].issuer, "https://", "")}:sub": "system:serviceaccount:kube-system:aws-load-balancer-controller",
          "${replace(aws_eks_cluster.eks_cluster.identity[0].oidc[0].issuer, "https://", "")}:aud": "sts.amazonaws.com"
        }
      }
    }]
  })

  managed_policy_arns = [aws_iam_policy.alb_controller_policy.arn]

}



##################################################
#       IAM RESOURCES CODEBUILD 
###################################################

# data "template_file" "codebuild_policy" {
#   template = file("${path.module}/policies/iam_codebuild_policy.json.tpl")

#   vars = {
#     ecr_repository_arn = aws_ecr_repository.eks_ecr_repository.arn
#     eks_cluster_arn    = aws_eks_cluster.eks_cluster.arn
#   }
# }

# resource "aws_iam_policy" "codebuild_policy" {
#   name        = "CodeBuildIAMPolicy"
#   description = "IAM policy for the CodeBuild project on EKS"
#   policy      = templatefile("${path.module}/policies/iam_codebuild_policy.json.tpl", {
#     ecr_repository_arn = aws_ecr_repository.eks_ecr_repository.arn,
#     eks_cluster_arn    = aws_eks_cluster.eks_cluster.arn
#   })
# }


# data "aws_iam_policy_document" "eks_assume_role_policy" {
#   statement {
#     actions = ["sts:AssumeRoleWithWebIdentity"]
#      condition {
#       test     = "StringEquals"
#       variable = "${aws_eks_cluster.eks_cluster.identity[0].oidc[0].issuer}:sub"
#       values   = ["system:serviceaccount:${var.eks_namespace}:my-serviceaccount"]
#       }
#     principals {
#       type        = "Federated"
#       identifiers = [aws_iam_openid_connect_provider.oidc_provider.arn]
#     }
#   }
# }

# resource "aws_iam_role" "eks_pod_role" {
#   name               = "${var.project_name}-eks-codebuild-role"
#   assume_role_policy = data.aws_iam_policy_document.eks_assume_role_policy.json
#   managed_policy_arns = [ aws_iam_policy.codebuild_policy.arn ]
# }


# resource "kubernetes_service_account" "eks_codebuild_sa" {
#   metadata {
#     name        = "eks-codebuild-sa"
#     namespace   = var.eks_namespace  
#     annotations = {
#       "eks.amazonaws.com/role-arn" = aws_iam_role.eks_pod_role.arn
#     }
#   }
# }

