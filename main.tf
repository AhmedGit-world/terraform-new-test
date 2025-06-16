provider "aws" {
  region = var.aws_region
}

resource "aws_iam_user" "ahmed_user" {
  name = "Ahmed"
  tags = {
    CreatedBy = "Terraform"
  }
}

resource "aws_iam_access_key" "ahmed_key" {
  user = aws_iam_user.ahmed_user.name
}

resource "aws_iam_user_policy_attachment" "attach_policy" {
  user       = aws_iam_user.ahmed_user.name
  policy_arn = var.policy_arn
}

output "access_key_id" {
  value = aws_iam_access_key.ahmed_key.id
}

output "secret_access_key" {
  value     = aws_iam_access_key.ahmed_key.secret
  sensitive = true
}
