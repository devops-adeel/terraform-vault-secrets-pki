terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.54.0"
    }
    vault = {
      version = "3.12.0"
      source  = "hashicorp/vault"
    }
  }
}
