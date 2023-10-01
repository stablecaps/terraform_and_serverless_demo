output "iam_role_arn" {
  description = "Lambda IAM role arn used for serverless function"
  value       = aws_iam_role.lambda_role.arn
}