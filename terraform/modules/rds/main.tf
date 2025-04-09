resource "aws_db_subnet_group" "rds" {
  name       = "rds-subnet-group-custom"
  subnet_ids = var.subnet_ids
  
  tags = {
    Name = "RDS subnet group custom-vpc"
  }

  lifecycle {
    create_before_destroy = true
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
  db_subnet_group_name   = aws_db_subnet_group.rds.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  skip_final_snapshot    = true
  deletion_protection    = true # Set to true to prevent accidental deletion
  tags = {
  Name = "mysql-instance"
}
}

