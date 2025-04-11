data "aws_ssm_parameter" "ssh_pub_key" {
  name = "/infra/ssh/my_key.pub"
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical


  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-20250305"]
  }
}
