terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "random" {}

provider "aws" {
  region  = "eu-west-2"
  profile = "sb_dev"
}

