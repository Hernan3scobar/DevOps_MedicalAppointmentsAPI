data "aws_ssm_parameter" "db_user" {
  name = "/rds/mysql/username"
  with_decryption = true
}

data "aws_ssm_parameter" "db_password" {
  name            = "/rds/mysql/password"
  
}

