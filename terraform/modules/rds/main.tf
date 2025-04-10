resource "null_resource" "rds_cleanup_wait" {
  depends_on = [aws_db_instance.default]

  triggers = {
    db_instance_id = aws_db_instance.default.identifier
  }

  provisioner "local-exec" {
    command = <<EOT
      echo "Waiting for RDS instance ${aws_db_instance.default.identifier} to be fully deleted..."
      aws rds wait db-instance-deleted \
        --db-instance-identifier ${aws_db_instance.default.identifier} || true
    EOT
  }
}

resource "aws_db_subnet_group" "rds" {
  name       = "rds-subnet-group-${sha256(join(",", var.subnet_ids))}"
  subnet_ids = var.subnet_ids
  
  tags = {
    Name = "RDS subnet group"
  }

  lifecycle {
    create_before_destroy = true
    prevent_destroy = false
    replace_triggered_by = [null_resource.rds_cleanup_wait] # Espera a que el wait termine
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

# Eliminated the egress rule for RDS because the database doesn't need outbound connections.


resource "aws_db_instance" "default" {
  allocated_storage      = 20
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = var.db_instance_class
  username               = "admin_user"
  password               = var.db_password
  db_subnet_group_name   = aws_db_subnet_group.rds.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  skip_final_snapshot    = true
  deletion_protection    = false

  tags = {
    Name = "mysql-instance"
  }

  depends_on = [aws_db_subnet_group.rds]

    lifecycle {
    # Espera a que el subnet group esté listo antes de crear
    replace_triggered_by = [aws_db_subnet_group.rds]
  }
}

