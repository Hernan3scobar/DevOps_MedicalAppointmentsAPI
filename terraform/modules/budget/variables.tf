variable "budget_name" {
  description = "The name of the budget"
  type        = string
}

variable "limit_amount" {
  description = "The budget limit in USD"
  type        = string
}

variable "services" {
  description = "List of AWS services to apply the budget to"
  type        = list(string)
}

variable "time_period_start" {
  description = "Start date for the budget in YYYY-MM-DD"
  type        = string
}

variable "time_period_end" {
  description = "End date for the budget in YYYY-MM-DD"
  type        = string
}

variable "notification_email" {
  description = "Email address to receive budget alerts"
  type        = string
}

variable "time_unit" {
  description = "Time unit for budget (DAILY, MONTHLY, or QUARTERLY)"
  type        = string
}
