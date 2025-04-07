variable "vpc_id" {}
variable "subnet_id" {}
variable "ssh_public_key" {
  description = "Public SSH key for EC2 instances"
  type        = string
}