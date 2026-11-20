terraform {
  required_version = ">= 1.2.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "project6" {
  bucket = "likitha-project6-version-control-demo-2026"

  tags = {
    Name        = "Project6"
    Environment = "Development"
    ManagedBy   = "Terraform"
  }
}
