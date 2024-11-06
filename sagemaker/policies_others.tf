resource "aws_iam_policy" "sagemaker_s3_access" {
  name        = module.iam_policy_sagemaker_s3.name
  description = "Sagemaker Studio S3 Access"
  policy = jsonencode(
    {
      Statement = [
        {
          Action = [
            "s3:GetObject",
            "s3:PutObject",
            "s3:DeleteObject",
            "s3:ListBucket",
          ]
          Effect = "Allow"
          Resource = [
            "arn:aws:s3:::*",
          ]
        },
      ]
      Version = "2012-10-17"
    }
  )
  tags = module.iam_policy_sagemaker_s3.tags
}

resource "aws_iam_policy" "sagemaker_secrets_manager" {
  name        = module.iam_policy_sagemaker_secrets.name
  description = "Sagemaker Studio Secrets Manager Access"
  policy = jsonencode(
    {
      Statement = [
        {
          Action   = "secretsmanager:GetSecretValue"
          Effect   = "Allow"
          Resource = "*"
          Sid      = "VisualEditor0"
        },
      ]
      Version = "2012-10-17"
    }
  )
  tags = module.iam_policy_sagemaker_secrets.tags
}