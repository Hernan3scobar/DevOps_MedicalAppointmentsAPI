# This file contains the variables used in the terraform code
# AWS Provider
region = "us-east-1"

vpc_cidr = "10.0.0.0/16"


#Budget 

budget_name        = "daily-budget"
limit_amount       = "0.02"
services           = ["AmazonEC2", "AmazonRDS", "AmazonVPC"]
time_period_start  = "2025-04-04_00:00"
time_period_end    = "2025-05-12_00:00"
notification_email = "hernanescobarsanchez@gmail.com"
time_unit          = "DAILY"
