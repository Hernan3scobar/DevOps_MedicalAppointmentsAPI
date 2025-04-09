data "aws_db_subnet_group" "existing" {
  count = var.allow_existing_subnet_group ? 1 : 0
  name  = "rds-subnet-group-custom"
}

resource "aws_db_subnet_group" "rds" {
  count    = var.allow_existing_subnet_group && length(data.aws_db_subnet_group.existing) > 0 ? 0 : 1
  name     = "rds-subnet-group-${sha256(join(",", var.subnet_ids))}"
  subnet_ids = var.subnet_ids
  
  tags = {
    Name = "RDS subnet group (auto-generated)"
  }
}
resource "aws_security_group" "rds_sg" {
  name        = "rds_sg"
  description = "Allow DB connections"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [var.ec2_sg_id]
    description = "Access from EC2"
  }
  tags = {
  Name = "sg-rds-mysql"
}
}

# Eliminated the egress rule for RDS because the database doesn't need outbound connections.

resource "aws_db_instance" "default" {
  allocated_storage      = 20
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = "db.t3.micro"
  username               = "admin_user" 
  password               = data.aws_ssm_parameter.db_password.value
  db_subnet_group_name = coalesce(
    try(data.aws_db_subnet_group.existing[0].name, ""),
    try(aws_db_subnet_group.rds[0].name, "default")
  )
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  skip_final_snapshot    = true
  deletion_protection    = true # Set to true to prevent accidental deletion
  tags = {
  Name = "mysql-instance"
}
}

