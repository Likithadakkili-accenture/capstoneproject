output "bucket_name" {
  description = "Created S3 bucket name"
  value       = aws_s3_bucket.website.id
}

output "website_endpoint" {
  description = "S3 static website endpoint"
  value       = aws_s3_bucket_website_configuration.website.website_endpoint
}

output "website_url" {
  description = "Public website URL"
  value       = "http://${aws_s3_bucket_website_configuration.website.website_endpoint}"
}
