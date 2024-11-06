data "aws_subnets" "subnet-2a" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
  tags = {
    Name = "*-app_internal_subnets-${var.region}a"
  }
}

data "aws_subnets" "subnet-2b" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
  tags = {
    Name = "*-app_internal_subnets-${var.region}b"
  }
}

data "aws_kms_key" "infra" {
  key_id = "alias/${upper(var.business_unit)}-${upper(var.application_name)}-${upper(var.environment)}-INFRA-DATA"
}

data "aws_ami" "internal_ami" {
  executable_users = ["self"]
  most_recent      = true
  owners           = ["902784830519"]
  filter {
    name   = "name"
    values = ["CIS_level_1_windows_cis_2019*"]
  }
}

data "aws_instances" "bobi_cms" {
  dynamic "filter" {
    for_each = var.cms_instance_filters
    content {
      name   = filter.value.name
      values = filter.value.values
    }
  }
  instance_state_names = ["running", "stopped"]
}

# data "aws_route53_zone" "this" {
#   name = var.hosted_zone_name

#   private_zone = true
# }

# data "aws_security_group" "ec2_multi" {
#   filter {
#     name = "group-name"
#     values = ["${var.business_unit}-${var.application_name}-${var.environment}-sg-boxi-ec2-nodes"]
#   }
# }
