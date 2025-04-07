
# This module creates an IAM role and policies for EC2 instances to access SSM parameters and manage budgets.
resource "aws_iam_role" "ec2_ssm_role" {
  name = "EC2SSMRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      },
    ]
  })
}

resource "aws_iam_policy" "ssm_read_policy" {
  name = "EC2ReadSSMSecure"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "ssm:GetParameter",
          "ssm:GetParameters",
          "ssm:GetParametersByPath"
        ],
        Resource = "*"
      },
      {
        Effect   = "Allow",
        Action   = "kms:Decrypt",
        Resource = "*"
      }
    ]
  })
}
# Allow management of budgets in AWS
resource "aws_iam_policy" "budget_policy" {
  name        = "AllowBudgetManagement"
  description = "Allow management of budgets in AWS"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "budgets:ViewBudget",
          "budgets:ModifyBudget",
          "budgets:CreateBudget",
          "budgets:DescribeBudget",
          "budgets:DeleteBudget"
        ],
        Resource = "*"
      }
    ]
  })
}
# Allow Jenkins to manage EC2 instances
resource "aws_iam_policy" "jenkins_permissions" {
  name = "JenkinsInfrastructureAccess"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [

      # RDS
      {
        Effect = "Allow",
        Action = [
          "rds:CreateDBInstance",
          "rds:DeleteDBInstance",
          "rds:DescribeDBInstances",
          "rds:ModifyDBInstance"
        ],
        Resource = "*"
      },

      # EC2
      {
        Effect = "Allow",
        Action = [
          "ec2:RunInstances",
          "ec2:DescribeInstances",
          "ec2:TerminateInstances",
          "ec2:DescribeSecurityGroups",
          "ec2:DescribeSubnets",
          "ec2:DescribeVpcs",
          "ec2:CreateTags"
        ],
        Resource = "*"
      },

      # VPC
      {
        Effect = "Allow",
        Action = [
          "ec2:CreateVpc",
          "ec2:DeleteVpc",
          "ec2:CreateSubnet",
          "ec2:DeleteSubnet",
          "ec2:DescribeRouteTables",
          "ec2:CreateRouteTable",
          "ec2:AssociateRouteTable"
        ],
        Resource = "*"
      },

      # IAM: 
      {
        Effect   = "Allow",
        Action   = "iam:PassRole",
        Resource = "*"
      }
    ]
  })
}
# Attach the policies to the EC2 role
resource "aws_iam_role_policy_attachment" "ssm_attach" {
  role       = aws_iam_role.ec2_ssm_role.name
  policy_arn = aws_iam_policy.ssm_read_policy.arn
}
# Attach the policies to budget management role
resource "aws_iam_role_policy_attachment" "budget_access" {
  role       = aws_iam_role.ec2_ssm_role.name
  policy_arn = aws_iam_policy.budget_policy.arn
}
# Attach the policies to Jenkins role
resource "aws_iam_role_policy_attachment" "jenkins_permissions_attach" {
  role       = aws_iam_role.ec2_ssm_role.name
  policy_arn = aws_iam_policy.jenkins_permissions.arn
}
# Create an instance profile for the EC2 role
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "EC2SSMProfile"
  role = aws_iam_role.ec2_ssm_role.name
}
