# AWS Provider Configuration

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
  region = var.aws_region
}


# Get Existing Default VPC

data "aws_vpc" "default" {
  default = true
}


# Get Subnets in Default VPC

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}


# Select Existing Subnet

data "aws_subnet" "public" {
  id = data.aws_subnets.default.ids[0]
}


# Get Latest Amazon Linux 2023 AMI

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


# Create Security Group

resource "aws_security_group" "web" {
  name        = "${var.project_name}-sg"
  description = "Allow HTTP traffic"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-sg"
  }
}


# Create EC2 Instance

resource "aws_instance" "web" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
  subnet_id              = data.aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.web.id]

  associate_public_ip_address = true

  user_data = <<-EOF
    #!/bin/bash

    dnf update -y
    dnf install -y httpd

    systemctl enable httpd
    systemctl start httpd

    cat <<'HTML' > /var/www/html/index.html
    <!DOCTYPE html>
    <html>
    <head>
      <title>My AWS Web Server</title>
      <style>
        body {
          font-family: Arial;
          text-align: center;
          background: #eef2f7;
          padding: 100px;
        }
        .container {
          background: white;
          padding: 40px;
          border-radius: 12px;
        }
        h1 {
          color: #232f3e;
        }
      </style>
    </head>
    <body>
      <div class="container">
        <h1>Welcome to My AWS Web Server!</h1>
        <h2>Successfully Deployed Using Terraform</h2>
        <p>AWS EC2 | Terraform | Linux | Apache</p>
      </div>
    </body>
    </html>
    HTML
  EOF

  tags = {
    Name = "${var.project_name}-ec2"
  }
}
