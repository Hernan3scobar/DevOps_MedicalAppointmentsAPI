terraform {
  backend "local" {
    organization = "SoftServe_Devops"

    workspaces {
      name = "terraform-infra"
    }
  }
}
