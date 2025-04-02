variable "region" {}
variable "vpc_cidr" {}
variable "db_password" {
  description = "Password for RDS"
  sensitive   = true
}
