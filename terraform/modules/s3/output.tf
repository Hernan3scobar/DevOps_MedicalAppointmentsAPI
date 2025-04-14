output "bucket_name" {
  description = "The name of the S3 bucket used by Ansible"
  value       = aws_s3_bucket.ssm_ansible_bucket.id
}
