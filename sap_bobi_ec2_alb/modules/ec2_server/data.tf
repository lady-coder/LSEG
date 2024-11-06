//This might be how we lookup the launch template??
# data "aws_launch_template" "bobi_server_lt" {

#   filter {
#     name = "launch-template-name"
#     #values = ["*launch-boxi-server"]
#     values = ["*-launch-sap-boxi-2cST7-server*"]
#   }
# }

data "aws_iam_instance_profile" "insprofile" {
  name = "${var.business_unit}-${var.application_name}-${var.environment}-insprofile-sap-boxi-ec2" 
}


data "aws_vpc" "default" {
  tags = {
    "Name" = var.default_vpc_name
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

data "aws_db_instance" "database" {
  db_instance_identifier = "${var.business_unit}-${var.application_name}-${var.environment}-rds-sap-boxi"
}

data "template_file" "userdata_server" {
  template = file("${path.module}/../../userdata-templates/userdata-server.tftpl")
  vars = {
    s3_bucket    = "${var.business_unit}-${var.application_name}-${var.environment}-s3-boxi-install"
    rds_host     = data.aws_db_instance.database.address // FIXME - need to look this one ip from an rds output
    tns_alias    = "${var.business_unit}-${var.application_name}-${var.environment}-rds-sap-boxi"
    ad_secret_id = "${upper("${var.business_unit}/${var.application_name}/${var.environment}")}/SAP/BOXI/WINDOWS/SHARE/SUPERUSER"
    fsx_secret_id = "${upper("${var.business_unit}/${var.application_name}/${var.environment}")}/SAP/BOXI/WINDOWS/SHARE/DNSNAME"
    default_region = var.region
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