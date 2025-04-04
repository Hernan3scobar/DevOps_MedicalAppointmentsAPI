module "vpc" {
  source     = "./modules/vpc"
  cidr_block = var.vpc_cidr
}

module "ec2" {
  source    = "./modules/ec2"
  vpc_id    = module.vpc.vpc_id
  subnet_id = module.vpc.public_subnet_id
}

module "rds" {
  source     = "./modules/rds"
  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnet_ids
  ec2_sg_id  = module.ec2.security_group_id
}