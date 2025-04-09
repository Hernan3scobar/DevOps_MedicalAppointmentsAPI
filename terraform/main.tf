terraform {
  cloud {
    organization = "Group1SoftServeDemo2"

    workspaces {
      name = "terrademo2"
    }
  }
}


module "vpc" {
  source     = "./modules/vpc"
  cidr_block = var.vpc_cidr
}

module "ec2" {
  source    = "./modules/ec2"
  vpc_id    = module.vpc.vpc_id
  subnet_id = module.vpc.public_subnet_id
  ssh_public_key   = var.ssh_public_key
}

module "rds" {
  source     = "./modules/rds"
  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnet_ids
  ec2_sg_id  = module.ec2.security_group_id
}

module "budget" {
  source              = "./modules/budget"
  budget_name         = var.budget_name
  limit_amount        = var.limit_amount
  time_unit           = var.time_unit
  services            = var.services
  time_period_start   = var.time_period_start
  time_period_end     = var.time_period_end
  notification_email  = var.notification_email
}
