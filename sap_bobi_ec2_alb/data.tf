data "aws_vpc" "default" {
  tags = {
    "Name" = var.default_vpc_name
  }
}


data "aws_subnets" "extended" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
  tags = {
    Name = "*-app_boxi_subnets-${var.region}*"
  }
}

data "aws_subnet" "boxisubs" {
  for_each = toset(data.aws_subnets.extended.ids)
  id       = each.key
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

data "aws_subnet" "subs" {
  for_each = toset(data.aws_subnets.private.ids)
  id       = each.key
}

data "aws_security_groups" "management" {

  filter {
    name = "vpc-id"
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

data "aws_security_groups" "ec2_rds" {
  filter {
    name   = "group-name"
    values = [module.sg_ec2_label.name]
  }
}


data "aws_security_groups" "alb_sg" {
  filter {
    name   = "group-name"
    values = [module.sg_lb_cms_label.name]
  }
}
