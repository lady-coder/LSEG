resource "aws_s3_bucket" "sagemaker-s3" {
  bucket        = module.s3_labels.name
  force_destroy = true
  tags = {
    Automation         = "PLACEHOLDER"
    CodeRepo           = "ssh://git@bitbucket.unix.lch.com:7999/dsrcp/terraform-aws-module-emr-msk-secrets.git"
    ApplicationName    = var.application_name
    ManagedBy          = var.managed_by
    Name               = module.s3_labels.name
    BusinessUnit       = var.business_unit
    AWSResourceType    = "S3"
    DataClassification = "Internal"
    Environment        = var.environment
    Region             = var.region
    ProjectCode        = var.project_code
    ApplicationId      = var.application_id
    CostCentre         = var.cost_centre
  }
}

resource "aws_s3_bucket_public_access_block" "sagemaker-s3" {
  depends_on = [
    aws_s3_bucket.sagemaker-s3
  ]

  bucket = aws_s3_bucket.sagemaker-s3.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_policy" "sagemaker-s3" {
  bucket = aws_s3_bucket.sagemaker-s3.id
  policy = data.aws_iam_policy_document.aggregate_policies.json

  depends_on = [
    aws_s3_bucket_public_access_block.sagemaker-s3
  ]
}


resource "aws_s3_bucket_server_side_encryption_configuration" "sagemaker-s3" {
  bucket = aws_s3_bucket.sagemaker-s3.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = var.kms_key_arn
      sse_algorithm     = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_versioning" "versions" {
  bucket = aws_s3_bucket.sagemaker-s3.id
  versioning_configuration {
    status = "Enabled"
  }
}

data "aws_iam_policy_document" "aggregate_policies" {
  statement {
    sid     = "DenyHTTPAccess"
    effect  = "Deny"
    actions = ["s3:*"]
    resources = [
      "arn:aws:s3:::${module.s3_labels.name}/*",
      "arn:aws:s3:::${module.s3_labels.name}"
    ]

    principals {
      identifiers = ["*"]
      type        = "AWS"
    }

    condition {
      test = "Bool"
      values = [
        "false"
      ]
      variable = "aws:SecureTransport"
    }
  }


}
