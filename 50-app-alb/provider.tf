terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.3.0"
    }
  }

  backend "s3" {
    bucket         = "expense-terraform-teju"
    key            = "expense-rds-dev"
    region         = "us-east-1"
    dynamodb_table = "expense_locking"
  }
}

provider "aws" {
  # Configuration options
  region = "us-east-1"
}