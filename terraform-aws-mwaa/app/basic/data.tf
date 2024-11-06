locals {
  tenant_map = [
    for k,v in var.tenants : {
      vpc  = v.vpc
      name  = k
    }
  ]

   vpc_names = toset(concat
    (([for item in var.tenants : try(item.vpc, var.vpc_name)])
  ))
  
}

data "aws_vpc" "this" {
  tags = {
    "Name" = var.vpc_name
  }
}

data "aws_subnets" "subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.this.id]
  }
  tags = {
    Name = "*-app_internal_subnets-${var.region}*"
  }
}

data "aws_iam_policy" "service_role_boundary" {
  name = "ServiceRoleBoundary"
}


data "aws_security_groups" "management" {

  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.this.id]
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

data "aws_partition" "this" {}

data "aws_region" "this" {}

data "aws_caller_identity" "this" {}


data "aws_vpc" "vpclookup" {
  for_each = toset(local.vpc_names)
  tags = {
    "Name" = each.key
  }
}

data "aws_subnets" "subnetlookups" {
  for_each = toset(local.vpc_names)
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.vpclookup[each.key].id]
  }
  tags = {
    Name = "*-app_internal_subnets-${var.region}*"
  }
}

data "aws_security_groups" "vpcmanagement" {
  for_each = toset(local.vpc_names)
  filter {
    name = "vpc-id"
    values = [data.aws_vpc.vpclookup[each.key].id]
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
