data "aws_ssm_parameter" "db_password" {
  name            = "/rds/mysql/password"
  with_decryption = true
}
