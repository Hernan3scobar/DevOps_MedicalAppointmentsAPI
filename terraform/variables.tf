# AWS region where resources will be deployed (e.g., "us-east-1")
variable "region" {
  description = "AWS region to deploy resources"
  type        = string
}

# CIDR block for the main VPC (e.g., "10.0.0.0/16")
variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

# Name of the AWS budget (e.g., "medical-api-budget")
variable "budget_name" {
  description = "Name for the AWS budget"
  type        = string
}

# Budget spending limit in USD (e.g., "5.00")
variable "limit_amount" {
  description = "Spending limit for the AWS budget in USD"
  type        = string
}

# List of AWS services to track in the budget (e.g., ["AmazonEC2", "AmazonRDS"])
variable "services" {
  description = "List of AWS services to monitor in the budget"
  type        = list(string)
}

# Start date of the budget in YYYY-MM-DD format
variable "time_period_start" {
  description = "Start date of the AWS budget (YYYY-MM-DD)"
  type        = string
}

# End date of the budget in YYYY-MM-DD format
variable "time_period_end" {
  description = "End date of the AWS budget (YYYY-MM-DD)"
  type        = string
}

# Email address for budget notifications
variable "notification_email" {
  description = "Email address to receive budget alerts"
  type        = string
}

# Time unit for budget tracking (e.g., "MONTHLY")
variable "time_unit" {
  description = "Time unit for the budget (e.g., MONTHLY)"
  type        = string
}

# Project prefix used in naming AWS resources
variable "project_name" {
  description = "Prefix used to name AWS resources"
  type        = string
}

# Environment name for deployment (e.g., "dev", "prod")
variable "environment" {
  description = "Environment name (e.g., dev, staging, prod)"
  type        = string
}
