module "label1" {
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
}

output "label1" {
  value = {
    name                 = module.label1.name
    tags                 = module.label1.tags
    tags_as_list_of_maps = module.label1.tags_as_list_of_maps
  }
}

output "input1_label" {
  value = module.label1.input
}

output "output1_vars" {
  value = module.label1.output_vars
}

output "default_tags_mnd" {
  value = module.label1.tags
}