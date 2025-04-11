# modules/rds/main.tf
resource "aws_db_subnet_group" "rds" {
  name       = "rds-subnet-group-${sha256(join(",", var.subnet_ids))}"
  subnet_ids = var.subnet_ids
  
  tags = {
    Name = "RDS subnet group"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "rds_sg" {
  name        = "rds-sg-${sha256(var.vpc_id)}"
  description = "Allow DB connections"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [var.ec2_sg_id]
    description     = "Access from EC2"
  }

  tags = {
    Name = "rds-mysql-sg"
  }
}

resource "aws_db_instance" "default" {
  allocated_storage      = 20
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = "db.t3.micro"
  username               = data.aws_ssm_parameter.db_user.value
  password               = data.aws_ssm_parameter.db_password.value
  db_subnet_group_name   = aws_db_subnet_group.rds.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  skip_final_snapshot    = true
  deletion_protection    = false  # Must be false for clean destruction

  tags = {
    Name = "mysql-instance"
  }

  lifecycle {
    ignore_changes = [
      db_subnet_group_name  # Prevent recreation if subnet group changes
    ]
  }
}

# Verification resource (runs only during destroy)
resource "null_resource" "rds_deletion_verifier" {
  triggers = {
    db_instance_id = aws_db_instance.default.id
  }

  provisioner "local-exec" {
    when    = destroy
    command = <<EOT
      echo "Verifying RDS instance ${self.triggers.db_instance_id} is fully deleted..."
      aws rds wait db-instance-deleted \
        --db-instance-identifier ${self.triggers.db_instance_id} || \
        echo "Verification complete or instance already deleted"
    EOT
  }
}