terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.23.0"
    }

    random = {
      source  = "hashicorp/random"
      version = "~>3.3.2"
    }
  }

  required_version = ">= 1.2.5"
}
