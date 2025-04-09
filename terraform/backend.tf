terraform {
  cloud {

    organization = "SoftServe_Devops"

    workspaces {
      name = "terraform-infra"
    }
  }
}