locals {
  availability_zone_subnets = {
    for s in data.aws_subnet.subs : s.availability_zone => s.id...
  }
  availability_zone_subnets_extended = {
    for s in data.aws_subnet.boxisubs : s.availability_zone => s.id...
  }
  boxi_map = [
    for k,v in var.boxi_environments : {
      server  = v.server
      client  = v.client
      env     = k
      vpc_name= try(v.vpc_name, var.default_vpc_name)
      subnet_filter = v.subnet_filter
      az_subnet_override = try(v.az_subnet_override, [])
      availability_zone_subnets = (v.subnet_filter == "internal" ? local.availability_zone_subnets : local.availability_zone_subnets_extended)
    }
  ]
}

locals {
  common_name = [
    var.environment == "poc" ? "sap" : "",
    "boxi"
  ]
  additional_names = var.enable_testing ? concat(local.common_name, [join("", random_string.random.*.result)]) : local.common_name
}
