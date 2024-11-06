module "this_label4" {
  source           = "../../app/module"
  environment      = var.environment
  business_unit    = var.business_unit
  region           = var.region
  application_name = var.application_name
  application_id   = var.application_id
  cost_centre      = var.cost_centre
  managed_by       = var.managed_by
  project_code     = var.project_code
  service_name     = var.service_name
  additional_names = var.additional_names
  code_repo        = var.code_repo

  name_use_case = "upper"
}

module "label4" {
  source = "../../app/module"

  environment      = var.environment
  region           = var.region
  application_name = var.application_name
  cost_centre      = var.cost_centre
  project_code     = var.project_code

  delimeter     = "|"
  resource_type = "s3"
  name_use_case = "upper"
  tag_me        = module.this_label4.annotate
}

output "label4" {
  value = {
    name                 = module.label4.name
    tags                 = module.label4.tags
    tags_as_list_of_maps = module.label4.tags_as_list_of_maps
  }
}

output "input4_label" {
  value = module.label4.input
}

output "output4_vars" {
  value = module.label4.output_vars
}
