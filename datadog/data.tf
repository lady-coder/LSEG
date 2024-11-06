data "aws_partition" "current" {}
data "aws_vpc" "default" {
  tags = {
    "Name" = var.default_vpc_name
  }
}

data "aws_subnets" "private" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
  tags = {
    Name = "*-app_internal_subnets-${var.region}*"
  }
}

data "aws_security_groups" "management" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
  filter {
    name = "group-name"
    values = [
      "Endpoint-Tier-*-SG",
      "Management-Tier-*-SG",
      "App-Tier-*-SG"
    ]
  }
}

data "aws_ami" "cis_red_hat7" {
  most_recent = true
  filter {
    name   = "name"
    values = ["redhat_linux_cis_7*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = var.ami_owners
}

data "aws_ami" "cis_red_hat8" {
  most_recent = true
  filter {
    name   = "name"
    values = ["redhat_linux_cis_8*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = var.ami_owners
}



data "aws_iam_policy" "datadog" {
  for_each = local.datadog.enabled ? local.managed_iam_policies : []
  name     = each.key
}

data "aws_iam_policy" "this" {
  name = "ServiceRoleBoundary"
}

data "aws_secretsmanager_secret" "datadog" {
  name = upper("${var.business_unit}/${var.application_name}/${var.environment}/DATADOG")
} 

data "aws_secretsmanager_secret_version" "datadog" {
  secret_id = data.aws_secretsmanager_secret.datadog.id
}

data "template_file" "bootstrap_data" {
  template = file("${path.module}/files/bootstrap.tftpl")
  vars = {
      dd_api_key = jsondecode(data.aws_secretsmanager_secret_version.datadog.secret_string)["DD_API_KEY"]
      sf_account    = jsondecode(data.aws_secretsmanager_secret_version.datadog.secret_string)["SF_ACCOUNT"]
      sf_user    = jsondecode(data.aws_secretsmanager_secret_version.datadog.secret_string)["SF_USER"]
      sf_password    = jsondecode(data.aws_secretsmanager_secret_version.datadog.secret_string)["SF_PASSWORD"]
      sf_warehouse    = jsondecode(data.aws_secretsmanager_secret_version.datadog.secret_string)["SF_WAREHOUSE"]
      sf_role    = jsondecode(data.aws_secretsmanager_secret_version.datadog.secret_string)["SF_ROLE"]
      secret_id_env = upper("${var.business_unit}/${var.application_name}/${var.environment}/DATADOG")
      region  = "${var.region}"
      BUCKET_NAME = aws_s3_bucket.bootstrap_bucket.bucket
  }
}
