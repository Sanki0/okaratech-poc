##################
#### POLICIES ####
##################


resource "aws_iam_policy" "sagemaker_studio_emr_cluster_discovery_policy" {
  name = "${var.prefix_resource_name}-${var.app_name}-studio-emr-cluster-discovery-policy"
  description = "allows sagemaker studio to discover emr clusters from sagemaker studio, attached to sagemaker-execution-role and its variants"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "elasticmapreduce:ListInstances",
          "elasticmapreduce:ListInstanceGroups",
          "elasticmapreduce:DescribeCluster",
          "elasticmapreduce:DescribeSecurityConfiguration",
          "elasticmapreduce:CreatePersistentAppUI",
          "elasticmapreduce:DescribePersistentAppUI",
          "elasticmapreduce:GetPersistentAppUIPresignedURL",
          "elasticmapreduce:GetOnClusterAppUIPresignedURL",
          "elasticmapreduce:ListClusters",
          "elasticmapreduce:GetClusterSessionCredentials",
          "iam:CreateServiceLinkedRole",
          "iam:GetRole"
        ]
        Effect = "Allow"
        Resource = "*"
      },
      {
        Action = [
          "iam:PassRole"
        ]
        Condition = {
          StringEquals = {
            "iam:PassedToService" = "sagemaker.amazonaws.com"
          }
        }
        Effect = "Allow"
        Resource = "*"
        Sid = "AllowPassRoleSageMaker"
      },
      {
        Action = [
          "elasticmapreduce:DescribeCluster",
          "elasticmapreduce:ListInstanceGroups",
          "elasticmapreduce:ListInstances",
          "elasticmapreduce:DescribeSecurityConfiguration"
        ]
        Effect = "Allow"
        Resource = "arn:aws:elasticmapreduce:*:*:cluster/*"
      },
      {
        Action = [
          "elasticmapreduce:ListClusters"
        ]
        Effect = "Allow"
        Resource = "*"
      },
      {
        Action = [
          "sagemaker:CreateProject",
          "sagemaker:DeleteProject"
        ]
        Effect = "Allow"
        Resource = "arn:aws:sagemaker:*:*:project/*"
      }
    ]

    
    # Version: "2012-10-17",
    # Statement: [
    #     {
    #         Effect: "Allow",
    #         Action: [
    #             "elasticmapreduce:CreatePersistentAppUI",
    #             "elasticmapreduce:DescribePersistentAppUI",
    #             "elasticmapreduce:GetPersistentAppUIPresignedURL",
    #             "elasticmapreduce:GetOnClusterAppUIPresignedURL"
    #         ],
    #         Resource: [
    #             "arn:aws:elasticmapreduce:region:accountID:cluster/*"
    #         ]
    #     },
    #     {
    #         Effect: "Allow",
    #         Action: [
    #            "elasticmapreduce:DescribeCluster",
    #            "elasticmapreduce:ListInstances",
    #            "elasticmapreduce:ListInstanceGroups",
    #            "elasticmapreduce:DescribeSecurityConfiguration"
    #         ],
    #         Resource: [
    #             "arn:aws:elasticmapreduce:region:accountID:cluster/*"
    #         ]
    #     },
    #     {
    #         Effect: "Allow",
    #         Action: [
    #             "elasticmapreduce:ListClusters"
    #         ],
    #         Resource: "*"
    #     }
    # ]

  })
}


resource "aws_iam_policy" "sagemaker_studio_presign_url_policy" {
  name = "${var.prefix_resource_name}-${var.app_name}-studio-presign-url-policy"
  description = "allows sagemaker studio users to create presigned urls, attached to sagemaker-access user group"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "sagemaker:CreatePresignedDomainUrl"
        ]
        Condition = {
          StringNotEquals = {
            "sagemaker:ResourceTag/iam" = "$${aws:username}"
          }
        }
        Effect = "Deny"
        Resource = "*"
        Sid = "AmazonSageMakerPresignedUrlPolicy"
      }
    ]
  })
}




###############
#### ROLES ####
###############

resource "aws_iam_role" "sagemaker_execution_role" {
  name = "${var.prefix_resource_name}-${var.app_name}-studio-execution-role"
  description = "attached to the studio domain"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Principal = {
          Service = "sagemaker.amazonaws.com"
        }
        Effect = "Allow"
      }
    ]
  })
  force_detach_policies = false
  managed_policy_arns = [
    aws_iam_policy.sagemaker_studio_emr_cluster_discovery_policy.arn,
    "arn:aws:iam::aws:policy/AmazonSageMakerFullAccess"
  ]
}

resource "aws_iam_role" "sagemaker_studio_user_role" {
  name = "${var.prefix_resource_name}-${var.app_name}-studio-user-role"
  description = "sagemaker studio user admin role with a s3 full access policy and kms full access policy"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Principal = {
          Service = "sagemaker.amazonaws.com"
        }
        Effect = "Allow"
      }
    ]
  })

  force_detach_policies = false
  managed_policy_arns = [
    aws_iam_policy.sagemaker_studio_emr_cluster_discovery_policy.arn,
    "arn:aws:iam::aws:policy/AmazonSageMakerFullAccess",
    "arn:aws:iam::aws:policy/AmazonS3FullAccess"
  ]
  
}
