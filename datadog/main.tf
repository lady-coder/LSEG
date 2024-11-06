module "datadog" {
  source = "git::ssh://bitbucket.unix.lch.com:7999/dsrcp/terraform-aws-module-ec2.git//app/modules/ec2?ref=v0.5.2"

  enabled          = local.datadog.enabled
  region           = var.region
  environment      = var.environment
  business_unit    = var.business_unit
  application_name = var.application_name
  application_id   = var.application_id
  cost_centre      = var.cost_centre
  project_code     = var.project_code
  additional_names = local.additional_names

  instance_type               = lookup(local.datadog, "instance_type", var.instance_type)
  user_data                   = data.template_file.bootstrap_data.rendered
  vpc_security_group_ids      = data.aws_security_groups.management.ids
  permissions_boundary_arn    = data.aws_iam_policy.this.arn
  ami                         = var.manual_ami  ? var.ami_id_manual : data.aws_ami.cis_red_hat7.id
  associate_public_ip_address = false
  root_block_device           = var.root_block_device
  subnet_id                   = sort(data.aws_subnets.private.ids)[0]
  managed_iam_policy_names    = local.managed_iam_policies
  additional_tags  = var.additional_tags
}

module "s3_label" {
  source = "git::ssh://bitbucket.unix.lch.com:7999/dsrcp/terraform-aws-module-tag-label.git//app/module?ref=v0.5.2"

  enabled          = var.enabled
  environment      = var.environment
  region           = var.region
  application_name = var.application_name
  application_id   = var.application_id
  cost_centre      = var.cost_centre
  managed_by       = var.managed_by
  project_code     = var.project_code
  service_name     = var.service_name
  code_repo        = var.code_repo
  business_unit    = var.business_unit

  additional_names = concat(["datadog-bootstrap"]) 
  resource_type    = "s3"
  name_use_case    = "lower"
}

resource "aws_s3_bucket" "bootstrap_bucket" {
  bucket = module.s3_label.name
  tags = module.s3_label.tags
}

resource "aws_s3_bucket_policy" "bootstrap_bucket_policy" {
  bucket = aws_s3_bucket.bootstrap_bucket.id
  policy = data.aws_iam_policy_document.bootstrap_bucket_policy_doc.json
}

data "aws_iam_policy_document" "bootstrap_bucket_policy_doc" {
  statement {
    sid     = "DenyHTTPAccess"
    effect  = "Deny"
    actions = ["s3:*"]
    resources = [
      "arn:${data.aws_partition.current.partition}:s3:::${aws_s3_bucket.bootstrap_bucket.id}",
      "arn:${data.aws_partition.current.partition}:s3:::${aws_s3_bucket.bootstrap_bucket.id}/*"
    ]

    principals {
      identifiers = ["*"]
      type        = "AWS"
    }

    condition {
      test     = "Bool"
      values   = ["false"]
      variable = "aws:SecureTransport"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "certbucket" {
  depends_on = [
    aws_s3_bucket.bootstrap_bucket
  ]

  bucket = aws_s3_bucket.bootstrap_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_object" "obj_s3" {
  for_each = fileset("${path.module}/files/", "*")

  bucket = aws_s3_bucket.bootstrap_bucket.bucket
  key    = each.value
  source = "${path.module}/files/${each.value}"
  etag   = filemd5("${path.module}/files/${each.value}")
}

