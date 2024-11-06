variable "name" {
  description = "Name of MWAA Environment"
  default     = "mwaa-bo-poc"
  type        = string
}

variable "vpc_name" {
  description = "VPC CIDR for MWAA"
  type        = string
  default     = "SNO-POC-BO-vpc"
}

variable "additional_names" {
  description = "tenant names"
  type        = any
}

variable "tenants" {
  description = "list of tenant env to provision"
  type        = any
}

variable "create_generic_mwaa" {
  description = "Create default mwaa"
  default     = false
}