

module "sg_ec2_label" {
  source = "git::ssh://bitbucket.unix.lch.com:7999/dsrcp/terraform-aws-module-tag-label.git//app/module?ref=v0.4.9"

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

module "sg_lb_cms_label" {
  source = "git::ssh://bitbucket.unix.lch.com:7999/dsrcp/terraform-aws-module-tag-label.git//app/module?ref=v0.4.9"

  enabled          = var.enabled
  environment      = var.environment
  region           = var.region
  application_name = var.application_name
  cost_centre      = var.cost_centre
  project_code     = var.project_code

  additional_names = concat(local.additional_names, ["lb", "cms"])
  resource_type    = "sg"
  additional_tags  = var.additional_tags
  tag_me = module.this.annotate
}

module "lb_cms_label" {
  source = "git::ssh://bitbucket.unix.lch.com:7999/dsrcp/terraform-aws-module-tag-label.git//app/module?ref=v0.4.9"

  enabled          = var.enabled
  environment      = var.environment
  region           = var.region
  application_name = var.application_name
  cost_centre      = var.cost_centre
  project_code     = var.project_code
  additional_tags  = var.additional_tags
  additional_names = concat(local.additional_names, ["cs"])
  resource_type    = "alb"

  tag_me = module.this.annotate
}

module "ec2_lt_label" {
  source = "git::ssh://bitbucket.unix.lch.com:7999/dsrcp/terraform-aws-module-tag-label.git//app/module?ref=v0.4.9"

  enabled          = var.enabled
  environment      = var.environment
  region           = var.region
  application_name = var.application_name
  cost_centre      = var.cost_centre
  project_code     = var.project_code
  automation       = "UK_ALLDAYS_START_NOSNAPSHOT_CET"

  additional_names = concat(local.additional_names, ["ec2"])
  resource_type    = "launch"
  additional_tags  = var.additional_tags
  tag_me = module.this.annotate
}
