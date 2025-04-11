resource "aws_budgets_budget" "daily_budget" {
  name              = var.budget_name
  budget_type       = "COST"
  limit_amount      = var.limit_amount
  limit_unit        = "USD"
  time_unit         = var.time_unit
  time_period_end   = var.time_period_end
  time_period_start = var.time_period_start

  cost_filter {
    name   = "Service"
    values = var.services
  }


  notification {
    comparison_operator        = "GREATER_THAN"
    notification_type          = "ACTUAL"
    threshold                  = 80
    threshold_type             = "PERCENTAGE"
    subscriber_email_addresses = [var.notification_email]


  }
}

