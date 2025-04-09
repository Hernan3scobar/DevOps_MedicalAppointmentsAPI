data "aws_ssm_parameter" "db_user" {
  name = "/rds/mysql/username"
}

data "aws_ssm_parameter" "db_password" {
  name            = "/rds/mysql/password"
  with_decryption = true
}

data "aws_ssm_parameter" "db_url" {
  name            = "/rds/mysql/db_url"
  with_decryption = true
}