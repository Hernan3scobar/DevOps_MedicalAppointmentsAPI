resource "aws_s3_bucket" "ssm_ansible_bucket" {
  bucket = "${var.project_name}-${var.environment}-ssm-bucket"
  force_destroy = true

  tags = {
    Name        = "SSM-Ansible-Bucket"
    Environment = var.environment
  }
}
