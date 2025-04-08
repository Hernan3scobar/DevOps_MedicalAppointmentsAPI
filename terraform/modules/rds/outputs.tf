output "endpoint" {
  value = aws_db_instance.default.endpoint
}
output "rds_sg_id" {    #added this output to get the security group id of the rds instance.
  value = aws_security_group.rds_sg.id
}