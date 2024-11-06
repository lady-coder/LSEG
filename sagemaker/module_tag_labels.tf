module "s3_labels" {
  source           = "git::ssh://bitbucket.unix.lch.com:7999/dsrcp/terraform-aws-module-tag-label.git//app/module?ref=v0.5.2"
  environment      = var.environment
  business_unit    = var.business_unit
  region           = var.region
  application_name = var.application_name
  application_id   = var.application_id
  cost_centre      = var.cost_centre
  managed_by       = var.managed_by
  project_code     = var.project_code
  service_name     = var.service_name
  code_repo        = var.code_repo
  resource_type    = "s3"
  additional_names = concat(["sagemaker"], ["bucket"])
  delimeter        = "-"
  name_use_case    = "lower"
  additional_tags = {
    "Tenant" = "Concorde",
    "Service" = "Sagemaker"
  }
}

module "service_access_security_group_tags" {
  source = "git::ssh://bitbucket.unix.lch.com:7999/dsrcp/terraform-aws-module-tag-label.git//app/module?ref=v0.5.2"

  enabled          = var.enabled
  environment      = var.environment
  business_unit    = var.business_unit
  region           = var.region
  application_name = var.application_name
  application_id   = var.application_id
  cost_centre      = var.cost_centre
  managed_by       = var.managed_by
  project_code     = var.project_code
  additional_names = concat(["sagemaker"], ["sg"])
  code_repo        = var.code_repo
  additional_tags = {
    "Tenant" = "Concorde",
    "Service" = "Sagemaker"
  }
}


module "interface_endpoint_tag_label" {
  source = "git::ssh://bitbucket.unix.lch.com:7999/dsrcp/terraform-aws-module-tag-label.git//app/module?ref=v0.5.2"
  environment              = var.environment
  business_unit            = var.business_unit
  region                   = var.region
  application_name         = var.application_name
  resource_type            = "vpcinterface"
  application_id           = var.application_id
  cost_centre              = var.cost_centre
  managed_by               = var.managed_by
  project_code             = var.project_code
  service_name             = var.service_name
  code_repo                = var.code_repo
  additional_names         = concat(["sagemaker"],["notebook"])
  name_use_case            = "upper"
  
  
}

module "iam_policy_sagemaker_core_1" {
  source           = "git::ssh://bitbucket.unix.lch.com:7999/dsrcp/terraform-aws-module-tag-label.git//app/module?ref=v0.5.2"
  enabled          = var.enabled
  environment      = var.environment
  business_unit    = var.business_unit
  region           = var.region
  application_name = var.application_name
  application_id   = var.application_id
  cost_centre      = var.cost_centre
  managed_by       = var.managed_by
  project_code     = var.project_code
  resource_type    = "policy"
  additional_names = concat(["sagemaker"], ["core_1"])
  code_repo        = var.code_repo
  additional_tags = {
    "Tenant" = "Concorde",
    "Service" = "Sagemaker"
  }
  
}

module "iam_policy_sagemaker_core_2" {
  source           = "git::ssh://bitbucket.unix.lch.com:7999/dsrcp/terraform-aws-module-tag-label.git//app/module?ref=v0.5.2"
  enabled          = var.enabled
  environment      = var.environment
  business_unit    = var.business_unit
  region           = var.region
  application_name = var.application_name
  application_id   = var.application_id
  cost_centre      = var.cost_centre
  managed_by       = var.managed_by
  project_code     = var.project_code
  resource_type    = "policy"
  additional_names = concat(["sagemaker"], ["core_2"])
  code_repo        = var.code_repo
  additional_tags = {
    "Tenant" = "Concorde",
    "Service" = "Sagemaker"
  }
}

module "iam_policy_sagemaker_core_3" {
  source           = "git::ssh://bitbucket.unix.lch.com:7999/dsrcp/terraform-aws-module-tag-label.git//app/module?ref=v0.5.2"
  enabled          = var.enabled
  environment      = var.environment
  business_unit    = var.business_unit
  region           = var.region
  application_name = var.application_name
  application_id   = var.application_id
  cost_centre      = var.cost_centre
  managed_by       = var.managed_by
  project_code     = var.project_code
  resource_type    = "policy"
  additional_names = concat(["sagemaker"], ["core_3"])
  code_repo        = var.code_repo
  additional_tags = {
    "Tenant" = "Concorde",
    "Service" = "Sagemaker"
  }
}

module "iam_policy_sagemaker_s3" {
  source           = "git::ssh://bitbucket.unix.lch.com:7999/dsrcp/terraform-aws-module-tag-label.git//app/module?ref=v0.5.2"
  enabled          = var.enabled
  environment      = var.environment
  business_unit    = var.business_unit
  region           = var.region
  application_name = var.application_name
  application_id   = var.application_id
  cost_centre      = var.cost_centre
  managed_by       = var.managed_by
  project_code     = var.project_code
  resource_type    = "policy"
  additional_names = concat(["sagemaker"], ["s3_access"])
  code_repo        = var.code_repo
}

module "iam_policy_sagemaker_secrets" {
  source           = "git::ssh://bitbucket.unix.lch.com:7999/dsrcp/terraform-aws-module-tag-label.git//app/module?ref=v0.5.2"
  enabled          = var.enabled
  environment      = var.environment
  business_unit    = var.business_unit
  region           = var.region
  application_name = var.application_name
  application_id   = var.application_id
  cost_centre      = var.cost_centre
  managed_by       = var.managed_by
  project_code     = var.project_code
  resource_type    = "policy"
  additional_names = concat(["sagemaker"], ["secrets"])
  code_repo        = var.code_repo
}

module "iam_sagemaker" {
  source           = "git::ssh://bitbucket.unix.lch.com:7999/dsrcp/terraform-aws-module-tag-label.git//app/module?ref=v0.5.2"
  enabled          = var.enabled
  environment      = var.environment
  business_unit    = var.business_unit
  region           = var.region
  application_name = var.application_name
  application_id   = var.application_id
  cost_centre      = var.cost_centre
  managed_by       = var.managed_by
  project_code     = var.project_code
  resource_type    = "role"
  additional_names = concat(["sagemaker"])
  code_repo        = var.code_repo
  additional_tags = {
    "Tenant" = "Concorde",
    "Service" = "Sagemaker"
  }
}

module "sagemaker_studio_label" {
  source           = "git::ssh://bitbucket.unix.lch.com:7999/dsrcp/terraform-aws-module-tag-label.git//app/module?ref=v0.5.2"
  enabled          = var.enabled
  environment      = var.environment
  business_unit    = var.business_unit
  region           = var.region
  application_name = var.application_name
  application_id   = var.application_id
  cost_centre      = var.cost_centre
  managed_by       = var.managed_by
  project_code     = var.project_code
  resource_type    = "sagemaker"
  additional_names = concat(["studio"])
  code_repo        = var.code_repo
  additional_tags = {
    "Tenant" = "Concorde",
    "Service" = "Sagemaker"
  }
}

module "sagemaker_domain" {
  source           = "git::ssh://bitbucket.unix.lch.com:7999/dsrcp/terraform-aws-module-tag-label.git//app/module?ref=v0.5.2"
  enabled          = var.enabled
  environment      = var.environment
  business_unit    = var.business_unit
  region           = var.region
  application_name = var.application_name
  application_id   = var.application_id
  cost_centre      = var.cost_centre
  managed_by       = var.managed_by
  project_code     = var.project_code
  resource_type    = "sagemaker"
  additional_names = concat(["domain"])
  code_repo        = var.code_repo
  additional_tags = {
    "Tenant" = "Concorde",
    "Service" = "Sagemaker"
  }
}

module "sagemaker_tenants_domain" {
  source           = "git::ssh://bitbucket.unix.lch.com:7999/dsrcp/terraform-aws-module-tag-label.git//app/module?ref=v0.5.2"
  for_each         = toset(var.tenants) 
  enabled          = var.enabled
  environment      = var.environment
  business_unit    = var.business_unit
  region           = var.region
  application_name = var.application_name
  application_id   = var.application_id
  cost_centre      = var.cost_centre
  managed_by       = var.managed_by
  project_code     = var.project_code
  resource_type    = "sagemaker"
  additional_names = concat([each.value],["domain"])
  code_repo        = var.code_repo
  additional_tags = {
    "Tenant" = each.value,
    "Service" = "Sagemaker"
  }
}

module "sagemaker_user" {
  source           = "git::ssh://bitbucket.unix.lch.com:7999/dsrcp/terraform-aws-module-tag-label.git//app/module?ref=v0.5.2"
  enabled          = var.enabled
  environment      = var.environment
  business_unit    = var.business_unit
  region           = var.region
  application_name = var.application_name
  application_id   = var.application_id
  cost_centre      = var.cost_centre
  managed_by       = var.managed_by
  project_code     = var.project_code
  resource_type    = "sagemaker"
  additional_names = concat(["user-profile"])
  code_repo        = var.code_repo
}


module "sagemaker_notebook" {
  source           = "git::ssh://bitbucket.unix.lch.com:7999/dsrcp/terraform-aws-module-tag-label.git//app/module?ref=v0.5.2"
  enabled          = var.enabled
  environment      = var.environment
  business_unit    = var.business_unit
  region           = var.region
  application_name = var.application_name
  application_id   = var.application_id
  cost_centre      = var.cost_centre
  managed_by       = var.managed_by
  project_code     = var.project_code
  resource_type    = "sagemaker"
  additional_names = concat(["notebook"])
  code_repo        = var.code_repo
  additional_tags = {
    "Tenant" = "Concorde",
    "Service" = "Sagemaker"
  }
}

module "sagemaker_studio_lifecycle" {
  source           = "git::ssh://bitbucket.unix.lch.com:7999/dsrcp/terraform-aws-module-tag-label.git//app/module?ref=v0.5.2"
  enabled          = var.enabled
  environment      = var.environment
  business_unit    = var.business_unit
  region           = var.region
  application_name = var.application_name
  application_id   = var.application_id
  cost_centre      = var.cost_centre
  managed_by       = var.managed_by
  project_code     = var.project_code
  resource_type    = "sagemaker"
  additional_names = concat(["studio"])
  code_repo        = var.code_repo
  additional_tags = {
    "Tenant" = "Concorde",
    "Service" = "Sagemaker"
  }
}


module "sagemaker_notebook_tenants" {
  source           = "git::ssh://bitbucket.unix.lch.com:7999/dsrcp/terraform-aws-module-tag-label.git//app/module?ref=v0.5.2"
  for_each         = toset(var.tenants) 
  enabled          = var.enabled
  environment      = var.environment
  business_unit    = var.business_unit
  region           = var.region
  application_name = var.application_name
  application_id   = var.application_id
  cost_centre      = var.cost_centre
  managed_by       = var.managed_by
  project_code     = var.project_code
  resource_type    = "sagemaker"
  additional_names = concat([each.value])
  code_repo        = var.code_repo
  additional_tags = {
    "Tenant" = each.value,
    "Service" = "Sagemaker"
  }
}

module "sagemaker_user_tenants" {
  source           = "git::ssh://bitbucket.unix.lch.com:7999/dsrcp/terraform-aws-module-tag-label.git//app/module?ref=v0.5.2"
  for_each         = toset(var.tenants) 
  enabled          = var.enabled
  environment      = var.environment
  business_unit    = var.business_unit
  region           = var.region
  application_name = var.application_name
  application_id   = var.application_id
  cost_centre      = var.cost_centre
  managed_by       = var.managed_by
  project_code     = var.project_code
  resource_type    = "sagemaker"
  additional_names = concat([each.value],["profile"])
  code_repo        = var.code_repo
}