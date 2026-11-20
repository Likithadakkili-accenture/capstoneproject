output "iam_user_name" {
  description = "Created IAM username"
  value       = aws_iam_user.s3_reader.name
}

output "iam_user_arn" {
  description = "IAM user ARN"
  value       = aws_iam_user.s3_reader.arn
}

output "attached_policy_name" {
  description = "Attached IAM policy name"
  value       = aws_iam_user_policy.s3_read_access.name
}
