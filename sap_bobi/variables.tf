################################################################################
# Route53
################################################################################
variable "hosted_zone_name" {
  type    = string
  default = null
}

variable "cms_lb_host_name" {
  type        = string
  description = "The host name that is prepended to the `hosted_zone_name' used to talk to the BOBI CMS nodes"
  default     = "prepoc-bobi"
}

################################################################################
# RDS Module Variables
################################################################################
variable "db_engine" {
  description = "The database engine to use"
  type        = string
  default     = "oracle-ee"
}

variable "db_engine_version" {
  description = "The engine version to use"
  type        = string
  default     = "12.1.0.2.v8"
}

variable "db_parameter_group_family" {
  description = "The family of the DB parameter group"
  type        = string
  default     = "oracle-ee-12.1"
}

variable "db_major_engine_version" {
  description = "Specifies the major version of the engine that this option group should be associated with"
  type        = string
  default     = "12.1"
}

variable "db_instance_class" {
  description = "The instance type of the RDS instance"
  type        = string
  default     = "db.t3.large"
}

variable "db_name" {
  description = "The DB name to create. If omitted, no database is created initially"
  type        = string
  default     = null
}

variable "db_master_username" {
  description = "Username for the master DB user"
  type        = string
  default     = null
}


variable "db_max_allocated_storage" {
  description = "Specifies the value for Storage Autoscaling"
  type        = number
  default     = 0
}

variable "db_allocated_storage" {
  description = "The allocated storage in gigabytes"
  type        = string
  default     = null
}

variable "db_master_secret" {
  description = "Password for the master DB user. Note that this may show up in logs, and it will be stored in the state file"
  type        = string
  default     = ""
}

variable "allowed_cidr_blocks" {
  description = "CIDR Ranges allowed For RDS Ingress"
  type        = list(string)
  default     = []
}

################################################################################
# FSX Module Variables
################################################################################
variable "fsx_enabled" {
  type        = bool
  default     = true
  description = "Enables/Disables the deployment of the AWS FSX service"
}

variable "fsx_storage_capacity" {
  type        = number
  default     = 32
  description = "Storage capacity in GiB"
}

variable "fsx_security_group_ids" {
  type    = list(string)
  default = []
}

variable "fsx_throughput_capacity" {
  type    = number
  default = 8
}

variable "fsx_self_managed_active_directory" {
  type = object({
    dns_ips        = list(string)
    domain_name    = string
    netbios_domain = string
    password       = string
    username       = string
    /* file_system_administrators_group       = string */
    organizational_unit_distinguished_name = string
  })
  default = null
}

variable "cidr_blocks" {
  type    = list(string)
  default = ["10.0.0.0/8"]
}

variable "fsxDnsName" {
  type  =   string  
}

################################################################################
# Secrets
################################################################################

variable "secret_recovery_window_in_days" {
  type    = number
  default = 7
}

################################################################################
# launch template
################################################################################

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

variable "instance_type" {
  type    = string
  default = "t2.2xlarge"
}

variable "storage_encrypted" {
  type    = bool
}



variable "iam_instance_profile_name" {
  type        = string
  description = "The IAM instance profile name to associate with launched instances"
  default     = ""
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

variable "tag_specifications_resource_types" {
  type        = set(string)
  default     = ["instance", "volume"]
  description = "List of tag specification resource types to tag. Valid values are instance, volume, elastic-gpu and spot-instances-request."
}

variable "network_interface_description" {
  type        = string
  description = "Primary network description"
  default     = null
}

variable "key_name" {
  type    = string
  default = "boxi_setup_key"
}

variable "subnet_id" {
  type        = string
  description = "The VPC Subnet ID to associate"
  default     = null
}

################################################################################
################################################################################
variable "cms_instance_filters" {
  type = list(object({
    name   = string
    values = list(string)
  }))
  default = [
    {
      name   = "platform"
      values = ["windows"]
    },
    {
      name   = "tag:Name"
      values = ["BOTST5S*"]
    }
  ]
  description = "A list of filters used to identify BOBI CMS instances"
}


variable "enable_testing" {
  type        = bool
  default     = false
  description = <<-EOF
  When set to `true` a randonmized string of 5 characters will be appended to the tenant name.
  This setting is used for test purposes to make sure that resources created by tests never clash
  EOF
}

variable "iam_role_name" {
  type        = string
  default     = "iamrole-sap-boxi-ec2" 
}

variable "boxi_cert_bucket" {
  type = string
}

variable "default_subnet_search" {
  type = string
  default = "*-app_internal_subnets-"
}

variable "default_vpc_name" {
  type = string
}

variable "db_kms_key" {
  type = string
}