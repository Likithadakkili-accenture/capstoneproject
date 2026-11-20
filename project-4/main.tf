terraform {
  required_version = ">= 1.2.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# AWS Provider
provider "aws" {
  region = var.aws_region
}

# Create IAM User
resource "aws_iam_user" "s3_reader" {
  name = var.iam_user_name

  tags = {
    Name        = var.iam_user_name
    Environment = "Capstone"
    Project     = "Project-4"
  }
}

# Attach S3 Read-Only Policy
resource "aws_iam_user_policy" "s3_read_access" {
  name = "S3ReadOnlyPolicy"

  user = aws_iam_user.s3_reader.name

  policy = var.s3_read_policy
}
