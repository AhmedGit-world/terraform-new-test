variable "aws_region" {
  description = "The AWS region to create resources in"
  type        = string
  default     = "us-east-1"
}

variable "policy_arn" {
  description = "IAM policy ARN to attach to the user"
  type        = string
  default     = "arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess"
}
