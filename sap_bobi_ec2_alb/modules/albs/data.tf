
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
    Name = "*-app_${var.subnet_filter}_subnets-${var.region}*"
  }
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

# dsrcp-838, commented most_recent and wild card search of ami name with "*"
data "aws_ami" "internal_ami" {
  executable_users = ["self"]
  # most_recent      = true
  owners           = ["902784830519"]
  filter {
    name   = "name"
    # values = ["CIS_level_1_windows_cis_2019*"]
    values   = [var.aws_ami_name]
  }
}

data "aws_kms_key" "infra" {
  key_id = "alias/${upper(var.business_unit)}-${upper(var.application_name)}-${upper(var.environment)}-INFRA-DATA"
}

data "aws_instances" "targets" {
  dynamic "filter" {
    for_each = var.target_group_instances
    content {
      name   = filter.value.name
      values = filter.value.values
    }
  }
  instance_state_names = ["running", "stopped"]

}
