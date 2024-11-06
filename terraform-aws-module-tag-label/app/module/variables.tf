variable "tag_me" {
  type = any
  default = {
    enabled                  = true
    environment              = null
    region                   = null
    business_unit            = null
    application_name         = null
    application_id           = null
    cost_centre              = null
    managed_by               = null
    project_code             = null
    data_classification      = null
    automation               = null
    resource_type            = ""
    service_name             = null
    additional_names         = []
    additional_tag_map       = {}
    code_repo                = null
    change_name_format_order = []
    delimeter                = null
    name_use_case            = null
    additional_tags          = {}
  }

  validation {
    condition     = lookup(var.tag_me, "name_use_case", null) == null ? true : contains(["none", "lower", "upper"], var.tag_me.name_use_case)
    error_message = "`name_use_case` must be either `none`, `lower` or `upper`."
  }
  validation {
    condition = lookup(var.tag_me, "environment", null) == null || contains(
      [
        "memtest", "res", "prod", "production", "test", "dev", "nonprod", "poc", "preprod", "qa", "sandbox", "uat", "rsch"
      ], lookup(var.tag_me, "environment", null) == null ? "" : lower(var.tag_me.environment)
    ) ? true : false
    error_message = "The environment is incorrect."
  }
  validation {
    condition     = can(regex("APP-\\d{5}", lookup(var.tag_me, "application_id"))) || lookup(var.tag_me, "application_id", null) == null ? true : false
    error_message = "The format is `APP-\\d\\d\\d\\d\\d`."
  }
}

variable "environment" {
  type        = string
  description = "Environment, e.g. 'prod', 'stage', 'test', 'dev'"
  validation {
    condition = contains([
      "memtest", "res", "prod", "production", "test", "dev", "nonprod", "poc", "preprod", "qa", "sandbox", "uat", "rsch"
    ], lower(var.environment))
    error_message = "The environment is incorrect."
  }
}

variable "region" {
  type        = string
  description = "The location which the resource that the label is applied to is located"
}

variable "business_unit" {
  type        = string
  description = "value"
  default     = null
}

variable "application_name" {
  type        = string
  description = <<-EOF
  This is the abbreviated application name as defined by the Cloud Account Naming and Tagging Standards document
  `https://lsegdocs.lseg.stockex.local/x/Cv7cAQ`
  EOF
}

variable "application_id" {
  type        = string
  description = "Used to identify disparate resource that are related to a specific application, managed by CTO in Saleforce"
  default     = null
  validation {
    condition     = can(regex("APP-\\d{5}", var.application_id)) || var.application_id == null
    error_message = "The format is `APP-\\d\\d\\d\\d\\d`."
  }
}

variable "cost_centre" {
  type        = string
  description = "Identifies part of LSEG that should be charged for the tagged AWS resources"
}

variable "managed_by" {
  type        = string
  description = "Used to idenitify resources created by CET"
  default     = "Terraform"
}

variable "project_code" {
  type        = string
  description = "Project code is the numerical value used to identify Projects in Oracle Financials"
}

variable "data_classification" {
  type        = string
  description = "Used to enable data classification of the data stored within AWS resources that support data storage"
  default     = "Internal"
}

variable "automation" {
  type        = string
  description = ""
  default     = "PLACEHOLDER"
}

variable "resource_type" {
  type        = string
  description = "This is the abbreviated name of the resource being labelled ie vm, cloudsql, bucket"
  default     = null
}

variable "service_name" {
  type        = string
  description = "Describe the function of a resource e.g. WebServer, MessageBroker, Database"
  default     = ""
}

variable "additional_names" {
  type        = list(string)
  description = ""
  default     = []
}

variable "additional_tags" {
  type        = map(string)
  description = "Additional tags which are added to the resource (e.g. `{\"Confidential\" : \"secret\"}`"
  default     = {}
}

variable "additional_tag_map" {
  type        = map(string)
  description = "Additional tags for appending to tags_as_list_of_maps. Not added to `additional_tags`."
  default     = {}
}

variable "code_repo" {
  type = string

  description = <<EOF
Name of the projects git repository and git post-fix excluding the protocol
e.g. github.com:joeblogs/terraform-aws-joeblogs-bastion
EOF
  default     = null
}

variable "change_name_format_order" {
  type        = list(string)
  default     = []
  description = "Used to change the order of the id/label"
}

variable "delimeter" {
  type        = string
  default     = null
  description = "This is a one character delimeter used to separate the various elements that make up the `name` tag"
  validation {
    condition     = var.delimeter == null ? true : length(var.delimeter) <= 1
    error_message = "The delimeter must be a string and one character long."
  }
}

variable "name_use_case" {
  type        = string
  description = "This is primarily used to change the case of a resources name"
  default     = null

  validation {
    condition     = var.name_use_case == null ? true : contains(["none", "lower", "upper"], var.name_use_case)
    error_message = "Allow values: `none`, `lower`, `upper`."
  }
}

variable "enabled" {
  type        = bool
  default     = null
  description = "Set to false to prevent the module from creating any resources"
}

