variable "vpc_id" {}
variable "subnet_ids" {
  type = list(string)
}

variable "ec2_sg_id" {
  description = "Security group ID of EC2 instance"
}

variable "db_instance_class" { #added this variable to get the instance class of the rds instance.
  description = "Instance class for the RDS instance"
  type        = string
  default     = "db.t3.micro"
}