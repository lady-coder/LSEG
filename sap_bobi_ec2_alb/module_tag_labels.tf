module "sg_ec2_label" {
  source = "git::ssh://bitbucket.unix.lch.com:7999/dsrcp/terraform-aws-module-tag-label.git//app/module?ref=v0.5.2"

  enabled          = var.enabled
  environment      = var.environment
  region           = var.region
  application_name = var.application_name
  cost_centre      = var.cost_centre
  project_code     = var.project_code

  additional_names = concat(local.additional_names, ["ec2"])
  resource_type    = "sg"
  additional_tags  = var.additional_tags
  tag_me = module.this.annotate
}

module "sg_ec2_boxi_label" {
  source = "git::ssh://bitbucket.unix.lch.com:7999/dsrcp/terraform-aws-module-tag-label.git//app/module?ref=v0.5.2"

  enabled          = var.enabled
  environment      = var.environment
  region           = var.region
  application_name = var.application_name
  cost_centre      = var.cost_centre
  project_code     = var.project_code

  additional_names = concat(local.additional_names, ["ec2"],["boxi"],["nodes"])
  resource_type    = "sg"
  additional_tags  = var.additional_tags
  tag_me = module.this.annotate
}

module "sg_lb_cms_label" {
  source = "git::ssh://bitbucket.unix.lch.com:7999/dsrcp/terraform-aws-module-tag-label.git//app/module?ref=v0.5.2"

  enabled          = var.enabled
  environment      = var.environment
  region           = var.region
  application_name = var.application_name
  cost_centre      = var.cost_centre
  project_code     = var.project_code

  additional_names = concat(["sap", "boxi"], ["lb", "cms"]) // Required As For LB SG This is Created in Sep Module with different Additional Names
  resource_type    = "sg"
  additional_tags  = var.additional_tags
  tag_me = module.this.annotate
}

module "lb_label" {
  source = "git::ssh://bitbucket.unix.lch.com:7999/dsrcp/terraform-aws-module-tag-label.git//app/module?ref=v0.5.2"

  enabled          = var.enabled
  environment      = var.environment
  region           = var.region
  application_name = var.application_name
  cost_centre      = var.cost_centre
  project_code     = var.project_code

  additional_names = concat(local.additional_names)
  //resource_type    = "alb"
  additional_tags  = var.additional_tags
  tag_me = module.this.annotate
}

module "ec2_lt_label_server" {
  source = "git::ssh://bitbucket.unix.lch.com:7999/dsrcp/terraform-aws-module-tag-label.git//app/module?ref=v0.5.2"

  enabled          = var.enabled
  environment      = var.environment
  region           = var.region
  application_name = var.application_name
  cost_centre      = var.cost_centre
  project_code     = var.project_code
  automation       = "UK_ALLDAYS_START_NOSNAPSHOT_CET"

  additional_names = concat(local.additional_names, ["boxi"], ["server"])
  additional_tags  = var.additional_tags
  tag_me = module.this.annotate
}

module "ec2_lt_label_client" {
  source = "git::ssh://bitbucket.unix.lch.com:7999/dsrcp/terraform-aws-module-tag-label.git//app/module?ref=v0.5.2"

  enabled          = var.enabled
  environment      = var.environment
  region           = var.region
  application_name = var.application_name
  cost_centre      = var.cost_centre
  project_code     = var.project_code
  automation       = "UK_ALLDAYS_START_NOSNAPSHOT_CET"

  additional_names = concat(local.additional_names, ["boxi"], ["client"])
  additional_tags  = var.additional_tags
  tag_me = module.this.annotate
}
