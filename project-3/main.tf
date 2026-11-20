# Terraform Configuration

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


# Get Existing Default VPC

data "aws_vpc" "default" {
  default = true
}


# Get Default VPC Subnets

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}


# Select Subnet

data "aws_subnet" "public" {
  id = data.aws_subnets.default.ids[0]
}


# Get Amazon Linux 2023 AMI

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}


# Create EC2 Instance

resource "aws_instance" "monitor" {
  ami                         = data.aws_ami.amazon_linux.id
  instance_type               = var.instance_type
  subnet_id                   = data.aws_subnet.public.id
  associate_public_ip_address = true

  user_data = file("${path.module}/scripts/userdata.sh")

  tags = {
    Name = "${var.project_name}-ec2"
  }
}


# Create CloudWatch CPU Alarm

resource "aws_cloudwatch_metric_alarm" "cpu_alarm" {
  alarm_name        = "${var.project_name}-cpu-alarm"
  alarm_description = "Alarm when EC2 CPU utilization exceeds threshold"

  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Average"
  threshold           = var.cpu_threshold

  dimensions = {
    InstanceId = aws_instance.monitor.id
  }

  treat_missing_data = "notBreaching"
}
