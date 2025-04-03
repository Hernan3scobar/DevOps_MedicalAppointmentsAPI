data "aws_ssm_parameter" "db_password" {
  name            = "/rds/postgres/password"
  with_decryption = true
}
