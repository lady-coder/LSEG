variable "enabled" {
  type    = bool
  default = true
}

variable "environment" {
  type        = string
  description = "Environment, e.g. 'prod', 'stage', 'test', 'dev'"
  default     = "poc"
}

variable "region" {
  type        = string
  description = "The location which the resource that the label is applied to is located"
  default     = ""
}

variable "business_unit" {
  type        = string
  description = "value"
  default     = "lch"
}

variable "application_name" {
  type        = string
  default     = "sno"
  description = <<-EOF
  This is the abbreviated application name as defined by the Cloud Account Naming and Tagging Standards document
  `https://lsegdocs.lseg.stockex.local/x/Cv7cAQ`
  EOF
}

variable "application_id" {
  type        = string
  description = "Used to identify disparate resource that are related to a specific application, managed by CTO in Saleforce"
  default     = "APP-12345"
  validation {
    condition     = can(regex("APP-\\d{5}", var.application_id))
    error_message = "The format is `APP-\\d\\d\\d\\d\\d`."
  }
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
  default     = ""
}

variable "code_repo" {
  type    = string
  default = ""
}

variable "emr_cluster_additional_names" {
  type        = list(string)
  description = "The additional names to add to the cluster name. The name is generated using the cluster_tags module"
  default     = ["emr", "cluster"]
}

variable "emr_cluster_additional_tags" {
  type        = map(any)
  description = "The additional tags to add to the cluster tags. The tags are generated using the cluster_tags module"
  default     = {}
}

# EMR Security group names and tags
variable "service_access_security_group_additional_names" {
  type        = list(string)
  description = "The additional names to add to the service access security group name. The name is generated using the service_access_security_group_tags module"
  default     = ["sg", "service", "access"]
}

variable "service_access_security_group_additional_tags" {
  type        = map(any)
  description = "The additional tags to add to the service access security group tags. The tags are generated using the service_access_security_group_tags module"
  default     = {}
}

variable "managed_master_security_group_additional_names" {
  type        = list(string)
  description = "The additional names to add to the managed master security group name. The names are generated using the managed_master_security_group_tags module"
  default     = ["sg", "managed", "master"]
}


variable "managed_master_security_group_additional_tags" {
  type        = map(any)
  description = "The additional tags to add to the managed master security group tags. The tags are generated using the managed_master_security_group_tags module"
  default     = {}
}

variable "managed_slave_security_group_additional_names" {
  type        = list(string)
  description = "The additional names to add to the managed slave security group name. The names are generated using the managed_slave_security_group_tags module"
  default     = ["sg", "managed", "slave"]
}


variable "managed_slave_security_group_additional_tags" {
  type        = map(any)
  description = "The additional tags to add to the managed slave security group tags. The tags are generated using the managed_slave_security_group_tags module"
  default     = {}
}

variable "master_security_group_additional_names" {
  type        = list(string)
  description = "The additional names to add to the master security group name. The names are generated using the master_security_group_tags module"
  default     = ["sg", "master"]
}


variable "master_security_group_additional_tags" {
  type        = map(any)
  description = "The additional tags to add to the master security group tags. The tags are generated using the master_security_group_tags module"
  default     = {}
}


variable "slave_security_group_additional_names" {
  type        = list(string)
  description = "The additional names to add to the managed slave security group name. The names are generated using the managed_slave_security_group_tags module"
  default     = ["sg", "slave"]
}


variable "slave_security_group_additional_tags" {
  type        = map(any)
  description = "The additional tags to add to the slave security group tags. The tags are generated using the slave_security_group_tags module"
  default     = {}
}

variable "security_config_additional_names" {
  type        = list(string)
  description = "The additional names to add to the emr security config resource name. The names are generated using the security_config_tags module"
  default     = ["security", "config"]
}

variable "iam_autoscaling_role_additional_names" {
  type        = list(string)
  description = "The additional names to add to the emr auotoscaling role name. The names are generated using the iam_autoscaling_role_tags module"
  default     = ["role", "autoscaling", "emr"]
}

variable "iam_service_role_additional_names" {
  description = "The additional names to add to the emr service role name. The names are generated using the iam_service_role_tags module"
  type        = list(string)
  default     = ["role", "service", "emr"]
}

variable "iam_emr_ec2_role_additional_names" {
  description = "The additional names to add to the emr ec2 role name. The names are generated using the iam_emr_ec2_role_tags module"
  type        = list(string)
  default     = ["role", "ec2", "emr"]
}

variable "iam_emr_ec2_profile_additional_names" {
  description = "The additional names to add to the emr ec2 instance profile name. The names are generated using the iam_emr_ec2_profile_tags module"
  type        = list(string)
  default     = ["instance-profile", "emr"]
}

variable "iam_emr_ec2_policy_additional_names" {
  description = "the additional names to add to the emr ec2 policy name. The names are generated using the iam_emr_ec2_policy_tags module"
  type        = list(string)
  default     = ["policy", "emr"]
}

variable "s3_labels_additional_names" {
  description = "the additional names to add to the emr s3 bucket names. The names are generated using the s3_labels module"
  type        = list(string)
  default     = ["emr"]
}

variable "iam_emrfs_policy_additional_names" {
  description = "the additional names to add to the emr emrfs policy name. The names are generated using the s3_labels module"
  type        = list(string)
  default     = ["emrfs", "policy"]
}

variable "iam_emrfs_role_additional_names" {
  description = "the additional names to add to the emrfs emrfs policy name. The names are generated using the s3_labels module"
  type        = list(string)
  default     = ["emrfs", "role"]
}


variable "service_name" {
  type    = string
  default = ""
}