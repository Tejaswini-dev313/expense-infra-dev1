terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "6.0.0"
    }
  }

backend "s3" {
  bucket = "expense-terraform-teju"
  key   = "expense-bastion"
  region = "us-east-1"
  dynamodb_table = "expense_locking"
}
}

provider "aws" {
  # Configuration options
  region = "us-east-1"
}