variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs for RDS"
  type        = list(string)
}

variable "ec2_sg_id" {
  description = "Security group ID of EC2 instance"
  type        = string
}

variable "db_instance_class" {
  description = "Instance class for the RDS instance"
  type        = string
  default     = "db.t3.micro"
}
variable "db_password" {
  description = "Password for the database administrator"
  type        = string
  sensitive   = true
}