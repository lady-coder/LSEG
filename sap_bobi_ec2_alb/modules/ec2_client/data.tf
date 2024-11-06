# data "aws_launch_template" "bobi_client_lt" {
#   filter {
#     name = "launch-template-name"
#     #values = ["*-launch-sap-boxi-client"]
#     values = ["*-launch-sap-boxi-2cST7-client*"]
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

data "template_file" "userdata_client" {
  template = file("${path.module}/../../userdata-templates/userdata-client.tftpl")
  vars = {
    s3_bucket    = "${var.business_unit}-${var.application_name}-${var.environment}-s3-boxi-install" #var.software_bucket
    ad_secret_id = "${upper("${var.business_unit}/${var.application_name}/${var.environment}")}/SAP/BOXI/WINDOWS/SHARE/SUPERUSER"
    fsx_secret_id = "${upper("${var.business_unit}/${var.application_name}/${var.environment}")}/SAP/BOXI/WINDOWS/SHARE/DNSNAME"
    secret_path    = "${upper("${var.business_unit}/${var.application_name}/${var.environment}")}/BOAPI" 
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