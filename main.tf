resource "aws_iam_user" "admin_user" {
  name = "Ahmed"
  tags = {
    description = "Technical Team Lead"
  }
}
