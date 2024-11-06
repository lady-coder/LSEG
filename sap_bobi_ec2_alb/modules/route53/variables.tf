variable "environment" {
  type        = string
  description = "Environment, e.g. 'prod', 'stage', 'test', 'dev'"
}

variable "region" {
  type        = string
  description = "The location which the resource that the label is applied to is located"

}

variable "business_unit" {
  type        = string
  description = "value"
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

  validation {
    condition     = can(regex("APP-\\d{5}", var.application_id))
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
}

variable "project_code" {
  type        = string
  description = "Project code is the numerical value used to identify Projects in Oracle Financials"
}

variable "boxi_environment_name" {
  description = "Boxi env name"
}

variable "tags" {

}

variable "r53_record_name" {
  type = string
}


variable "alb_dns_name" {

}

variable "hosted_zone_name" {

}

variable "alb_zone_id" {
  
}