# Terraform AWS Infrastructure

This Terraform configuration deploys a basic infrastructure in AWS that includes:

- A Virtual Private Cloud (VPC)
- One EC2 instance (​Ubuntu 22.04 LTS)
- One RDS MySQL database

## Structure

```
terraform-aws-iac/
│
├── main.tf
├── provider.tf
├── variables.tf
├── terraform.tfvars
├── outputs.tf
├── modules/
│   ├── vpc/
│   ├── ec2/
│   └── rds/
```

## Requirements

- Terraform >= 1.0
- AWS CLI with configured credentials

## Usage

```bash
terraform init
terraform plan
terraform apply
```

## Outputs

- `vpc_id`: ID of the created VPC
- `ec2_public_ip`: Public IP of the EC2 instance
- `rds_endpoint`: RDS connection endpoint
