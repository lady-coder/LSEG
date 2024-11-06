variable "aws_ami_name" {
  type        = string
  description = "Currently using AMI name which will get updated with new builds and will have differnt ID "
}

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

variable "primary_az" {
  type = string
}


variable "secondary_az" {
  type = string
}


variable "subnet_2a" {
  type = string
}
variable "subnet_2b" {
  type = string
}
variable "subnet_2c" {
  type = string
}

variable "key_name" {
  type    = string
  default = "boxi_setup_key"
}

variable "instance_type" {
  type    = string
  default = "t2.2xlarge"
}

variable "block_device_mappings" {
  description = "Specify volumes to attach to the instance besides the volumes specified by the AMI"

  type = list(object({
    device_name  = string
    no_device    = bool
    virtual_name = string
    ebs = object({
      delete_on_termination = bool
      encrypted             = bool
      iops                  = number
      kms_key_id            = string
      snapshot_id           = string
      volume_size           = number
      volume_type           = string
    })
  }))

  default = []
}

variable "ebs_optimized" {
  type        = bool
  description = "If true, the launched EC2 instance will be EBS-optimized"
  default     = false
}

variable "disable_api_termination" {
  type        = bool
  description = "If `true`, enables EC2 Instance Termination Protection"
  default     = false
}

variable "instance_initiated_shutdown_behavior" {
  type        = string
  description = "Shutdown behavior for the instances. Can be `stop` or `terminate`"
  default     = "terminate"
}

variable "instance_market_options" {
  description = "The market (purchasing) option for the instances"

  type = object({
    market_type = string
    spot_options = object({
      block_duration_minutes         = number
      instance_interruption_behavior = string
      max_price                      = number
      spot_instance_type             = string
      valid_until                    = string
    })
  })

  default = null
}

variable "enable_monitoring" {
  type        = bool
  description = "Enable/disable detailed monitoring"
  default     = true
}

variable "associate_public_ip_address" {
  type        = bool
  description = "Associate a public IP address with an instance in a VPC"
  default     = false
}


variable "ec2_security_groups" {

}

variable "tags" {

}


variable "default_vpc_name" {
  type = string
}

variable "az_subnet_override" {
  type = list
  default = []
}
