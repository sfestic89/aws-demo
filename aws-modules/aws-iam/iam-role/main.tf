resource "aws_iam_role" "iam_role" {
  name               = var.name
  assume_role_policy = var.assume_role_policy
  description        = var.description
  path               = var.path
  tags               = var.tags
}