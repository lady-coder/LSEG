module "mwaa_tags" {
  source           = "git::ssh://bitbucket.unix.lch.com:7999/dsrcp/terraform-aws-module-tag-label.git//app/module?ref=v0.5.2"
  environment      = var.environment
  business_unit    = var.business_unit
  region           = var.region
  application_name = var.application_name
  application_id   = var.application_id
  cost_centre      = var.cost_centre
  resource_type    = "airflow"
  managed_by       = var.managed_by
  project_code     = var.project_code
  code_repo        = var.code_repo
  additional_names = var.additional_names //["mwaa"]
  additional_tags  = var.additional_tags
}


module "s3_tags" {
  source           = "git::ssh://bitbucket.unix.lch.com:7999/dsrcp/terraform-aws-module-tag-label.git//app/module?ref=v0.5.2"
  environment      = var.environment
  business_unit    = var.business_unit
  region           = var.region
  application_name = var.application_name
  application_id   = var.application_id
  cost_centre      = var.cost_centre
  resource_type    = "s3"
  managed_by       = var.managed_by
  project_code     = var.project_code
  code_repo        = var.code_repo
  additional_names = var.additional_names //["mwaa"]
  additional_tags  = var.additional_tags
}

module "mwaa_env_tags" {
  for_each = {for kv in local.tenant_map : kv.name => kv}
  source   = "git::ssh://bitbucket.unix.lch.com:7999/dsrcp/terraform-aws-module-tag-label.git//app/module?ref=v0.5.2"

  environment      = var.environment
  business_unit    = var.business_unit
  region           = var.region
  application_name = var.application_name
  application_id   = var.application_id
  cost_centre      = var.cost_centre
  resource_type    = "airflow"
  managed_by       = var.managed_by
  project_code     = var.project_code
  code_repo        = var.code_repo
  additional_names = [each.key]
  additional_tags = {
    "Tenant"  = each.key,
    "Service" = "Airflow"
  }
}

module "s3_env_tags" {
  for_each = {for kv in local.tenant_map : kv.name => kv}
  source   = "git::ssh://bitbucket.unix.lch.com:7999/dsrcp/terraform-aws-module-tag-label.git//app/module?ref=v0.5.2"

  environment      = var.environment
  business_unit    = var.business_unit
  region           = var.region
  application_name = var.application_name
  application_id   = var.application_id
  cost_centre      = var.cost_centre
  resource_type    = "s3"
  managed_by       = var.managed_by
  project_code     = var.project_code
  code_repo        = var.code_repo
  additional_names = [each.key]
  additional_tags = {
    "Tenant"  = each.key,
    "Service" = "Airflow"
  }
}

module "iam_mwaa" {
  source           = "git::ssh://bitbucket.unix.lch.com:7999/dsrcp/terraform-aws-module-tag-label.git//app/module?ref=v0.5.2"
  environment      = var.environment
  business_unit    = var.business_unit
  region           = var.region
  application_name = var.application_name
  application_id   = var.application_id
  cost_centre      = var.cost_centre
  managed_by       = var.managed_by
  project_code     = var.project_code
  resource_type    = "role"
  additional_names = var.additional_names //["mwaa"]
  code_repo        = var.code_repo
  additional_tags  = var.additional_tags
}


module "sg" {
  source           = "git::ssh://bitbucket.unix.lch.com:7999/dsrcp/terraform-aws-module-tag-label.git//app/module?ref=v0.5.2"
  environment      = var.environment
  business_unit    = var.business_unit
  region           = var.region
  application_name = var.application_name
  application_id   = var.application_id
  cost_centre      = var.cost_centre
  managed_by       = var.managed_by
  project_code     = var.project_code
  resource_type    = "sg"
  additional_names = var.additional_names //["mwaa"]
  code_repo        = var.code_repo
  additional_tags  = var.additional_tags
}

module "secrets_label" {
  for_each = {for kv in local.tenant_map : kv.name => kv}
  source   = "git::ssh://bitbucket.unix.lch.com:7999/dsrcp/terraform-aws-module-tag-label.git//app/module?ref=v0.5.2"

  environment      = var.environment
  region           = var.region
  application_name = var.application_name
  cost_centre      = var.cost_centre
  project_code     = var.project_code
  business_unit    = var.business_unit
  application_id   = var.application_id
  managed_by       = var.managed_by
  code_repo        = var.code_repo
  delimeter        = "/"
  name_use_case    = "upper"
  additional_names = [each.key]
  resource_type    = "mwaasecret"
  additional_tags = {
    "Tenant"  = each.key,
    "Service" = "Airflow"
  }

}

module "secrets_label_mwaa" {
  source = "git::ssh://bitbucket.unix.lch.com:7999/dsrcp/terraform-aws-module-tag-label.git//app/module?ref=v0.5.2"

  environment      = var.environment
  region           = var.region
  application_name = var.application_name
  cost_centre      = var.cost_centre
  project_code     = var.project_code
  business_unit    = var.business_unit
  application_id   = var.application_id
  managed_by       = var.managed_by
  code_repo        = var.code_repo
  delimeter        = "/"
  name_use_case    = "upper"
  additional_names = var.additional_names
  resource_type    = "secret"
  additional_tags = {
    "Tenant"  = "Concorde",
    "Service" = "Airflow"
  }

}

variable "environment" {
  type        = string
  description = "Environment, e.g. 'prod', 'stage', 'test', 'dev'"
  default     = "poc"
}

variable "region" {
  type        = string
  description = "The location which the resource that the label is applied to is located"
  default     = "eu-west-2"
}

variable "business_unit" {
  type        = string
  description = "value"
  default     = "lch"
}

variable "application_name" {
  type        = string
  description = <<-EOF
  This is the abbreviated application name as defined by the Cloud Account Naming and Tagging Standards document
  `https://lsegdocs.lseg.stockex.local/x/Cv7cAQ`
  EOF
  default     = "sno"
}

variable "application_id" {
  type        = string
  description = "Used to identify disparate resource that are related to a specific application, managed by CTO in Saleforce"

  validation {
    condition     = can(regex("APP-\\d{5}", var.application_id))
    error_message = "The format is `APP-\\d\\d\\d\\d\\d`."
  }
  default = "APP-12345"
}

variable "cost_centre" {
  type        = string
  description = "Identifies part of LSEG that should be charged for the tagged AWS resources"
  default     = "cc12345"
}

variable "managed_by" {
  type        = string
  description = "Used to idenitify resources created by CET"
  default     = "Terraform"
}

variable "project_code" {
  type        = string
  description = "Project code is the numerical value used to identify Projects in Oracle Financials"
  default     = "12345-123"
}

variable "code_repo" {
  type    = string
  default = "git::ssh://bitbucket.unix.lch.com:7999/dsrcp/terraform-aws-mwaa.git"
}

variable "additional_tags" {
  default = {
    "Tenant"  = "Concorde",
    "Service" = "Airflow"
  }
}
