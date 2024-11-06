module "label2" {
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
  name_use_case    = "lower"
}

output "label2" {
  value = {
    name                 = module.label2.name
    tags                 = module.label2.tags
    tags_as_list_of_maps = module.label2.tags_as_list_of_maps
  }
}

output "input2_label" {
  value = module.label2.input
}

output "output2_vars" {
  value = module.label2.output_vars
}