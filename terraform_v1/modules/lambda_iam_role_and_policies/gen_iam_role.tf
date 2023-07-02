locals {
  lambda_role_name = "exif-ripper-${var.env}-eu-west-1-lambdaRole"
}

resource "aws_iam_role" "lambda_role" {
  name_prefix = local.lambda_role_name

  description = "lambda iam role for exif-ripper - ${var.env}"

  path = "/lambda/${var.env}/"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
    ]
  })

  lifecycle {
    create_before_destroy = true
  }

  tags = merge({ Name = local.lambda_role_name }, var.tags)
}
