# main.tf
provider "aws" {
  region = "us-east-1" # Or your preferred AWS region, e.g., "ap-south-1" for Mumbai
}

resource "aws_s3_bucket" "example_bucket" {
  bucket = var.bucket_name # This variable will be passed from Jenkins
  acl    = "private"

  tags = {
    Environment = "Dev"
    Project     = "JenkinsNewTestRepo"
    ManagedBy   = "Terraform"
  }
}

variable "bucket_name" {
  description = "Name for the S3 bucket (must be globally unique)"
  type        = string
}

output "bucket_name_output" {
  value       = aws_s3_bucket.example_bucket.id
  description = "The name of the S3 bucket created"
}
