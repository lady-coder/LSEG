data "aws_region" "current" {}

data "aws_vpc" "default" {
  tags = {
    "Name" = var.default_vpc_name
  }
}

data "aws_subnets" "subnets" {
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

data "aws_iam_policy" "service_role_boundary" {
  name = "ServiceRoleBoundary"
}