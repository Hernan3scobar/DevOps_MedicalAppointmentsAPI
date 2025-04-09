variable "region" {
  type    = string
  default = "us-east-1"
}
variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "budget_name" {}
variable "limit_amount" {}
variable "services" {
  description = "AWS Services to monitor in the budget"
  type        = list(string)
  default     = ["AmazonEC2", "AmazonRDS", "AmazonVPC"] # Valores por defecto
}
variable "time_period_start" {}
variable "time_period_end" {}
variable "notification_email" {}
variable "time_unit" {}
variable "ssh_public_key" {
  description = "Public SSH key for EC2 instances"
  type        = string
  default     = "" # Puede estar vacío por defecto
  sensitive = true
}
variable "db_password" {
  description = "The password for the MySQL database"
  type        = string
  sensitive   = true
}