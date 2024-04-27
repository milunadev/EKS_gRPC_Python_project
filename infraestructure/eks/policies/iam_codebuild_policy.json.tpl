{
    "Version": "2012-10-17",
    "Statement": [
        {
        "Action": [
            "ecr:GetAuthorizationToken"
        ],
        "Resource": "*",
        "Effect": "Allow"
        },
        {
            "Effect": "Allow",
            "Action": [
              "ecr:GetDownloadUrlForLayer",
              "ecr:BatchGetImage",
              "ecr:BatchCheckLayerAvailability",
              "ecr:PutImage",
              "ecr:InitiateLayerUpload",
              "ecr:UploadLayerPart",
              "ecr:CompleteLayerUpload"
            ],
            "Resource": ["${ecr_repository_client_arn}","${ecr_repository_server_arn}"]
        },
        {
            "Effect": "Allow",
            "Action": [
                "eks:*"
            ],
            "Resource": "${eks_cluster_arn}"
        },
        {
            "Effect": "Allow",
            "Resource": [
                "*"
            ],
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ]
        }
    ]
}
