output "instance_id" {
  description = "EC2 instance ID"
  value       = aws_instance.monitor.id
}

output "public_ip" {
  description = "EC2 public IP"
  value       = aws_instance.monitor.public_ip
}

output "alarm_name" {
  description = "CloudWatch alarm name"
  value       = aws_cloudwatch_metric_alarm.cpu_alarm.alarm_name
}

output "cpu_threshold" {
  description = "Configured CPU threshold"
  value       = aws_cloudwatch_metric_alarm.cpu_alarm.threshold
}
