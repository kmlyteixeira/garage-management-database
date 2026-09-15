terraform {
  required_version = ">= 1.9.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }

  cloud {
    organization = "15soat-fiap"

    workspaces {
      name = "garage-management-database"
    }
  }
}

provider "aws" {
  region = var.region
}
