# IAM Role for EC2 to allow SSM access
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
      }
    ]
  })
}

#  Use the AWS-managed policy that enables SSM (secure and complete)
resource "aws_iam_role_policy_attachment" "ssm_managed_policy" {
  role       = aws_iam_role.ec2_ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# Create an instance profile to attach the role to the EC2 instance
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "EC2SSMProfile"
  role = aws_iam_role.ec2_ssm_role.name
}
