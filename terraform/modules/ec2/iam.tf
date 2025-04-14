
# IAM Role for EC2 to allow SSM access
resource "aws_iam_role" "ec2_ssm_role" {
  name = "${var.project_name}-${var.environment}-ec2-ssm-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# Attach SSM managed policy
resource "aws_iam_role_policy_attachment" "ssm_managed_policy" {
  role       = aws_iam_role.ec2_ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}


# Additional inline policy for S3 bucket
resource "aws_iam_policy" "s3_ansible_policy" {
  name        = "${var.project_name}-${var.environment}-s3-ansible-policy"
  description = "Allow EC2 to use Ansible SSM bucket"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:ListBucket"
        ],
        Resource = [
          "arn:aws:s3:::${var.project_name}-${var.environment}-ssm-bucket",
          "arn:aws:s3:::${var.project_name}-${var.environment}-ssm-bucket/*"
        ]
      }
    ]
  })
}

# Attach custom S3 policy to EC2 role
resource "aws_iam_role_policy_attachment" "s3_ansible_attachment" {
  role       = aws_iam_role.ec2_ssm_role.name
  policy_arn = aws_iam_policy.s3_ansible_policy.arn
}

# Instance profile to attach to EC2
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "${var.project_name}-${var.environment}-instance-profile"
  role = aws_iam_role.ec2_ssm_role.name
}
