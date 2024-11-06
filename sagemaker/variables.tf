variable "default_vpc_name" {
  type    = string
  default = "SNO-POC-BO-vpc"
}

variable "kms_key_arn" {
  type    = string
  default = "arn:aws:kms:eu-west-2:522557265874:key/45581624-b8f2-47d5-8eb1-d3dbfc26526e"
}

variable "cidr_blocks" {
  type    = list(string)
  default = ["10.0.0.0/8"]
}

variable "tenants" {
  type = list
}