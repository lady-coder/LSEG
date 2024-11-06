variable "boxi_environments" {
  type = any
}

variable "primary_az" {
  type    = string
  default = ""
}


variable "secondary_az" {
  type    = string
  default = ""
}


variable "enable_testing" {
  type        = bool
  default     = false
  description = <<-EOF
  When set to `true` a randonmized string of 5 characters will be appended to the tenant name.
  This setting is used for test purposes to make sure that resources created by tests never clash
  EOF
}

variable "cidr_blocks" {
  type    = list(string)
  default = ["10.0.0.0/8"]
}

variable "aws_ami_name" {
  type        = string
  description = "Currently using AMI name which will get updated with new builds and will have differnt ID "
}

variable "boxi_cert_domain" {
  type = string
}

variable "key_name" {
  type = string
}

variable "default_vpc_name" {
  type = string
}

variable "hosted_zone_name" {
  type    = string
}
