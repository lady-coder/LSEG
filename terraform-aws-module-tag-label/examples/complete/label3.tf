module "label3" {
  source           = "../../app/module"
  environment      = var.environment
  business_unit    = var.business_unit
  region           = var.region
  application_name = var.application_name
  application_id   = var.application_id
  cost_centre      = var.cost_centre
  managed_by       = var.managed_by
  project_code     = var.project_code
  resource_type    = var.resource_type
  service_name     = var.service_name
  additional_names = var.additional_names
  code_repo        = var.code_repo
  delimeter        = "+"
  name_use_case    = "upper"
}

output "label3" {
  value = {
    name                 = module.label3.name
    tags                 = module.label3.tags
    tags_as_list_of_maps = module.label3.tags_as_list_of_maps
  }
}

output "input3_label" {
  value = module.label3.input
}

output "output3_vars" {
  value = module.label3.output_vars
}