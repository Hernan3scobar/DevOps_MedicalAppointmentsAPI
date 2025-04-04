variable "vpc_id" {}
variable "subnet_ids" {
  type = list(string)
}

variable "ec2_sg_id" {
  description = "Security group ID of EC2 instance"
}
