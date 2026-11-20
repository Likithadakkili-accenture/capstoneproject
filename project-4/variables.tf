variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "iam_user_name" {
  description = "IAM username"
  type        = string
}

variable "s3_read_policy" {
  description = "S3 read-only IAM policy"
  type        = string
}
