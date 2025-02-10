##################
#### POLICIES ####
##################

resource "aws_iam_policy" "emr_ec2_policy" {
  name        = "emr_ec2_policy"
  description = "Allows EMR to call AWS services on your behalf to manage EC2 instances"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "cloudwatch:List*",
          "cloudwatch:Get*",
          "cloudwatch:Create*",
          "cloudwatch:Delete*",
          "cloudwatch:Update*",
          "cloudformation:CreateStack",
          "cloudformation:DescribeStackEvents",
          "ec2:AuthorizeSecurityGroupIngress",
          "ec2:AuthorizeSecurityGroupEgress",
          "ec2:CancelSpotInstanceRequests",
          "ec2:CreateRoute",
          "ec2:CreateSecurityGroup",
          "ec2:CreateTags",
          "ec2:DeleteRoute",
          "ec2:DeleteTags",
          "ec2:DeleteSecurityGroup",
          "ec2:DescribeAvailabilityZones",
          "ec2:DescribeAccountAttributes",
          "ec2:DescribeInstances",
          "ec2:DescribeKeyPairs",
          "ec2:DescribeRouteTables",
          "ec2:DescribeSecurityGroups",
          "ec2:DescribeSpotInstanceRequests",
          "ec2:DescribeSpotPriceHistory",
          "ec2:DescribeSubnets",
          "ec2:DescribeVpcAttribute",
          "ec2:DescribeVpcs",
          "ec2:DescribeRouteTables",
          "ec2:DescribeNetworkAcls",
          "ec2:CreateVpcEndpoint",
          "ec2:ModifyImageAttribute",
          "ec2:ModifyInstanceAttribute",
          "ec2:RequestSpotInstances",
          "ec2:RevokeSecurityGroupEgress",
          "ec2:RunInstances",
          "ec2:TerminateInstances",
          "elasticloadbalancing:DescribeTargetHealth",
          "elasticloadbalancing:RegisterTargets",
          "elasticloadbalancing:DeregisterTargets",
          "elasticmapreduce:*",
          "iam:GetPolicy",
          "iam:GetPolicyVersion",
          "iam:ListRoles",
          "iam:PassRole",
          "kms:List*"
        ]
        Effect   = "Allow"
        Resource = [
          "arn:aws:elasticmapreduce:${var.region}:${data.aws_caller_identity.current.account_id}:*",
          "arn:aws:ec2:${var.region}:${data.aws_caller_identity.current.account_id}:*",
          "arn:aws:elasticloadbalancing:${var.region}:${data.aws_caller_identity.current.account_id}:loadbalancer/*/*/*",
          "arn:aws:elasticloadbalancing:${var.region}:${data.aws_caller_identity.current.account_id}:loadbalancer/*/*",
          "arn:aws:elasticloadbalancing:${var.region}:${data.aws_caller_identity.current.account_id}:loadbalancer/*",
          "arn:aws:elasticloadbalancing:${var.region}:${data.aws_caller_identity.current.account_id}:*",
          "arn:aws:elasticloadbalancing:${var.region}:${data.aws_caller_identity.current.account_id}:targetgroup/*"
        ]
        Condition = {
          StringEquals = {
            "aws:SourceAccount" = data.aws_caller_identity.current.account_id
          }
        }
      },
      {
        Action = [
          "events:PutRule",
        ]
        Effect = "Allow"
        Resource = [
          "*"
        ]
      }
      # {
      #   Action   = "iam:CreateServiceLinkedRole"
      #   Effect   = "Allow"
      #   Resource = "*"
      #   Condition = {
      #     StringLike = {
      #       "iam:AWSServiceName" = [
      #         "elasticmapreduce.amazonaws.com"
      #       ]
      #     }
      #   }
      # }
    ]
  })

}



###############
#### ROLES ####
###############


resource "aws_iam_role" "emr_role" { # service role
  name        = "emr_role"
  description = "Allows EMR to call AWS services on your behalf"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "elasticmapreduce.amazonaws.com"
        }
        Condition = {
          StringEquals = {
            "aws:SourceAccount" = data.aws_caller_identity.current.account_id
          }
        }
        # ArnLike = {
        #   "aws:SourceArn" = "arn:aws:elasticmapreduce:${var.region}:${data.aws_caller_identity.current.account_id}:*"
        # }
      }
    ]
  })
  force_detach_policies = false
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/service-role/AmazonElasticMapReduceRole",
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore",
    "arn:aws:iam::aws:policy/service-role/AmazonEMRServicePolicy_v2",
    "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
  ]
}

resource "aws_iam_role" "emr_ec2_role" { # instance profile
  name        = "emr_ec2_role"
  description = "Allows EMR to call AWS services on your behalf to manage EC2 instances"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
  force_detach_policies = false
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/service-role/AmazonElasticMapReduceforEC2Role",
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore",
    "arn:aws:iam::aws:policy/SecretsManagerReadWrite",
    aws_iam_policy.emr_ec2_policy.arn,
    "arn:aws:iam::aws:policy/SecretsManagerReadWrite"
  ]
}

resource "aws_iam_instance_profile" "emr_ec2_instance_profile_role" {
  name = "emr_ec2_instance_profile_role"
  role = aws_iam_role.emr_ec2_role.name
}
