data "aws_caller_identity" "current" {}

data "aws_iam_policy" "service_role_boundary" {
  name = "ServiceRoleBoundary"
}

data "aws_s3_bucket" "this" {
  bucket = "${var.business_unit}-${var.application_name}-${var.environment}-s3-boxi-install"
}

data "aws_s3_bucket" "rds" {
  bucket = "${var.business_unit}-${var.application_name}-${var.environment}-s3-rds"
}


data "aws_kms_key" "by_alias" {
  key_id = "alias/${var.business_unit}-${var.application_name}-${var.environment}-kms-tenant-s3-data-cmk"
}

module "iam-tags" {
  source = "git::ssh://bitbucket.unix.lch.com:7999/dsrcp/terraform-aws-module-tag-label.git//app/module?ref=v0.5.0"

  environment      = var.environment
  business_unit    = var.business_unit
  region           = var.region
  application_name = var.application_name
  resource_type    = "iam"
  application_id   = var.application_id
  cost_centre      = var.cost_centre
  managed_by       = var.managed_by
  project_code     = var.project_code
  code_repo        = var.code_repo
  additional_names = var.additional_names
  change_name_format_order = [
    "BusinessUnit",
    "ApplicationName",
    "Environment",
    "AdditionalNames",
    "AWSResourceType",
  ]
  name_use_case = "upper"
}

resource "aws_iam_instance_profile" "ins_profile" {
  name = "${var.business_unit}-${var.application_name}-${var.environment}-insprofile-sap-boxi-ec2"
  role = "${aws_iam_role.ec2-role.name}"
  tags  = module.iam-tags.tags
}

resource "aws_iam_role" "ec2-role" {
  name                 = "${var.business_unit}-${var.application_name}-${var.environment}-iamrole-sap-boxi-ec2-role"
  permissions_boundary = data.aws_iam_policy.service_role_boundary.arn
  assume_role_policy   = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
               "Service": "ec2.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF
  tags  = module.iam-tags.tags
}

resource "aws_iam_policy" "ec2-policy" {
  name   = "${var.business_unit}-${var.application_name}-${var.environment}-ec2-policy"
  policy = data.aws_iam_policy_document.kms_access.json
}

resource "aws_iam_role_policy_attachment" "ec2-attach" {
  role       = aws_iam_role.ec2-role.name
  policy_arn = aws_iam_policy.ec2-policy.arn
}

data "aws_iam_policy" "secrets-policy" {
  arn = "arn:aws:iam::aws:policy/SecretsManagerReadWrite"
}

data "aws_iam_policy" "ssm-managed" {
  arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

data "aws_iam_policy" "ssm-directory" {
  arn = "arn:aws:iam::aws:policy/AmazonSSMDirectoryServiceAccess"
}

resource "aws_iam_role_policy_attachment" "ec2-secrets-attach" {
  role       = aws_iam_role.ec2-role.name
  policy_arn = data.aws_iam_policy.secrets-policy.arn
}

resource "aws_iam_role_policy_attachment" "ec2-ssm" {
  role       = aws_iam_role.ec2-role.name
  policy_arn = data.aws_iam_policy.ssm-managed.arn
}

resource "aws_iam_role_policy_attachment" "ec2-ssmdirectory" {
  role       = aws_iam_role.ec2-role.name
  policy_arn = data.aws_iam_policy.ssm-directory.arn
}

data "aws_iam_policy_document" "kms_access" {
  statement {
    effect = "Allow"
    actions = [
      "s3:ListAllMyBuckets",
      "s3:PutObject",
      "s3:GetObject",
      "s3:GetObjectVersion",
      "s3:DeleteObject",
      "s3:DeleteObjectVersion",
      "s3:ListBucket",
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:GenerateDataKey",
      "kms:ReEncryptTo",
      "kms:DescribeKey",
      "kms:ReEncryptFrom",
      "kms:GenerateDataKeyWithoutPlaintext",
      "kms:CreateGrant"
    ]
    resources = [
      "arn:aws:kms:${var.region}:${data.aws_caller_identity.current.account_id}:key/${data.aws_kms_key.by_alias.id}",
      "arn:aws:s3:::${data.aws_s3_bucket.this.id}",
      "arn:aws:s3:::${data.aws_s3_bucket.this.id}/*",
      "arn:aws:s3:::${data.aws_s3_bucket.rds.id}",
      "arn:aws:s3:::${data.aws_s3_bucket.rds.id}/*"
    ]
  }
}