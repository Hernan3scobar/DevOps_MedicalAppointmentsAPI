terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
provider "aws" {
  region = var.region
}


//
//provider "aws" {
//  region                   = var.region
//  shared_credentials_files = ["~/.aws/credentials"]
//  profile                  = "9080-2738-5722"
//}

// The provider is commented out because the aws-credentials is passing
// through the CI/CD pipeline in jenkins credentials.

