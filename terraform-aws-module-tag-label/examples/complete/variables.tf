#####
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
  type = string
}

variable "business_unit" {
  type = string
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

variable "code_repo" {
  type = string

  description = <<EOF
Name of the projects git repository and git post-fix excluding the protocol
e.g. github.com:joeblogs/terraform-aws-joeblogs-bastion
EOF
  default     = ""
}

