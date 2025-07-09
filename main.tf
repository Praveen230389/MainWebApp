# main.tf

# 1. Terraform block (specify version and backend if needed)
terraform {
  required_version = ">= 1.6.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

resource "aws_key_pair" "global" {
  key_name   = "global-key"
  public_key = file("/home/haudharys/.ssh/global-key.pub")
}

resource "aws_instance" "example" {
  ami           = "ami-0c02fb55956c7d316"
  instance_type = "t2.micro"
  key_name      = aws_key_pair.global.key_name

  tags = {
    Name = "MyEC2Instanceparttwo"
  }
}

# 2. Provider block (AWS example)
provider "aws" {
  region = var.aws_region
  # credentials usually come from environment variables or IAM role
}

# 3. Resources
resource "aws_s3_bucket" "example" {
  bucket = var.bucket_name

  tags = {
    Name        = "MyBucket"
    Environment = "Dev"
  }
}

# 4. Outputs
output "bucket_name" {
  description = "The name of the bucket"
  value       = aws_s3_bucket.example.id
}

# variables.tf

variable "aws_region" {
  description = "The AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "bucket_name" {
  description = "The name of the S3 bucket"
  type        = string
  default     = "my-default-bucket-name"
}
