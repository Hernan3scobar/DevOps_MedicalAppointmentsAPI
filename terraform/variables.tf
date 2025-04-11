variable "region" {}
variable "vpc_cidr" {}

variable "budget_name" {}
variable "limit_amount" {}
variable "services" {
  type = list(string)
}
variable "time_period_start" {}
variable "time_period_end" {}
variable "notification_email" {}
variable "time_unit" {}
