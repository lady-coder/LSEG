variable "datadog" {
  type    = any
  default = {}
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}
variable "key_name" {
  type    = string
  default = "lch-sno-poc-data-platform-rest-service-keys"
}
variable "ami_owners" {
  type    = list(string)
  default = ["902784830519"]
}

variable "enable_testing" {
  type    = bool
  default = false
}

variable "default_vpc_name" {
  type = string
}

variable "ami_id_manual" {
  type = string
}

variable  "manual_ami"{
  type    = bool
}

variable "root_block_device" {
  type = list(any)
  default = [  ]
}