module "boxi_ec2_server_instances" {

  source = "./modules/ec2_server"

  for_each = {for kv in local.boxi_map : kv.env => kv}
  

  business_unit         = var.business_unit
  region                = var.region
  environment           = var.environment
  application_name      = var.application_name
  application_id        = var.application_id
  cost_centre           = var.cost_centre
  managed_by            = var.managed_by
  project_code          = var.project_code
  primary_az            = var.primary_az
  secondary_az          = var.secondary_az
  boxi_environment_name = each.value
  subnet_2a             = var.application_name == "cncddr"?each.value.availability_zone_subnets.eu-west-1a[0]:each.value.availability_zone_subnets.eu-west-2a[0]
  subnet_2b             = var.application_name == "cncddr"?each.value.availability_zone_subnets.eu-west-1b[0]:each.value.availability_zone_subnets.eu-west-2b[0]
  subnet_2c             = var.application_name == "cncddr"?each.value.availability_zone_subnets.eu-west-1c[0]:each.value.availability_zone_subnets.eu-west-2c[0]
  #rds_security_groups   = data.aws_security_groups.ec2_rds.*.ids
  ec2_security_groups   = aws_security_group.boxi_ec2.id
  key_name              = var.key_name
  default_vpc_name      = each.value.vpc_name
  aws_ami_name          = var.aws_ami_name
  
  tags                  = module.ec2_lt_label_server.tags
}

module "boxi_ec2_client_instances" {

  source = "./modules/ec2_client"

  for_each = {for kv in local.boxi_map : kv.env => kv}

  business_unit         = var.business_unit
  region                = var.region
  environment           = var.environment
  application_name      = var.application_name
  application_id        = var.application_id
  cost_centre           = var.cost_centre
  managed_by            = var.managed_by
  project_code          = var.project_code
  primary_az            = var.primary_az
  secondary_az          = var.secondary_az
  az_subnet_override    = each.value.az_subnet_override
  boxi_environment_name = each.value
  subnet_2a             = var.application_name == "cncddr"?each.value.availability_zone_subnets.eu-west-1a[0]:each.value.availability_zone_subnets.eu-west-2a[0]
  subnet_2b             = var.application_name == "cncddr"?each.value.availability_zone_subnets.eu-west-1b[0]:each.value.availability_zone_subnets.eu-west-2b[0]
  subnet_2c             = var.application_name == "cncddr"?each.value.availability_zone_subnets.eu-west-1c[0]:each.value.availability_zone_subnets.eu-west-2c[0]
  #rds_security_groups   = data.aws_security_groups.ec2_rds.*.ids
  ec2_security_groups   = aws_security_group.boxi_ec2.id
  tags                  = module.ec2_lt_label_client.tags
  key_name              = var.key_name
  default_vpc_name      = each.value.vpc_name
  aws_ami_name          = var.aws_ami_name
}



module "boxi_ec2_albs" {

  source = "./modules/albs"

  for_each = {for kv in local.boxi_map : kv.env => kv}
  business_unit         = var.business_unit
  region                = var.region
  environment           = var.environment
  application_name      = var.application_name
  application_id        = var.application_id
  cost_centre           = var.cost_centre
  managed_by            = var.managed_by
  project_code          = var.project_code
  boxi_environment_name = each.value
  alb_security_groups   = flatten([aws_security_group.bo_lbs.id])
  tags                  = module.lb_label.tags
  alb_name              = "${module.lb_label.name}-${each.value.env}"
  subnet_filter         = each.value.subnet_filter
  target_group_instances = [
    {
      name   = "platform"
      values = ["windows"]
    },
    {
      name   = "tag:Name"
      values = module.boxi_ec2_server_instances[each.key].ec2_servers
    }
  ]

  aws_ami_name          = var.aws_ami_name
  default_vpc_name  = each.value.vpc_name
  boxi_cert_domain  = var.boxi_cert_domain
  alb_depends_on = length(module.boxi_ec2_server_instances[each.key].ec2_servers) == 4

}

module "boxi_ec2_client_albs" {

  source = "./modules/albs_client"

  for_each = {for kv in local.boxi_map : kv.env => kv}
  business_unit         = var.business_unit
  region                = var.region
  environment           = var.environment
  application_name      = var.application_name
  application_id        = var.application_id
  cost_centre           = var.cost_centre
  managed_by            = var.managed_by
  project_code          = var.project_code
  boxi_environment_name = each.value
  alb_security_groups   = flatten([aws_security_group.bo_lbs.id])
  tags                  = module.lb_label.tags
  # alb_name              = "${module.lb_label.name}-cli-${each.value.env}"
  # added below if-else as it throws error name cannot be > 32 chars as it's building name for DR as "lch-cncddr-preprod-boxi-cli-BOPPD1"
  alb_name              = var.application_name == "cncddr" ? "${module.lb_label.name}--${each.value.env}" : "${module.lb_label.name}-cli-${each.value.env}"
  subnet_filter         = each.value.subnet_filter
  //server_instance_ids   = module.boxi_ec2_server_instances[each.key]
  //client_instance_ids   = module.boxi_ec2_client_instances[each.key]
  target_group_instances = [
    {
      name   = "platform"
      values = ["windows"]
    },
    {
      name   = "tag:Name"
      values = module.boxi_ec2_client_instances[each.key].ec2_clients
    }
  ]


  alb_depends_on = length(module.boxi_ec2_client_instances[each.key].ec2_clients) == 2
  boxi_cert_domain  = var.boxi_cert_domain
  default_vpc_name  = each.value.vpc_name
}


module "boxi_client_route53" {

  source = "./modules/route53"

  for_each = {for kv in local.boxi_map : kv.env => kv}
  business_unit         = var.business_unit
  region                = var.region
  environment           = var.environment
  application_name      = var.application_name
  application_id        = var.application_id
  cost_centre           = var.cost_centre
  managed_by            = var.managed_by
  project_code          = var.project_code
  boxi_environment_name = each.value.env
  tags                  = module.lb_label.tags
  hosted_zone_name      = var.hosted_zone_name
  r53_record_name       = lower("${var.environment}-${each.value.env}-client")
  alb_dns_name          = module.boxi_ec2_client_albs[each.key].lb_dns_name[0]
  alb_zone_id           = module.boxi_ec2_client_albs[each.key].lb_zone_id[0]
}

module "boxi_server_route53" {

  source = "./modules/route53"

  for_each = {for kv in local.boxi_map : kv.env => kv}
  business_unit         = var.business_unit
  region                = var.region
  environment           = var.environment
  application_name      = var.application_name
  application_id        = var.application_id
  cost_centre           = var.cost_centre
  managed_by            = var.managed_by
  project_code          = var.project_code
  boxi_environment_name = each.value.env
  tags                  = module.lb_label.tags
  hosted_zone_name      = var.hosted_zone_name
  r53_record_name       = lower("${var.environment}-${each.value.env}")
  alb_dns_name          = module.boxi_ec2_albs[each.key].lb_dns_name[0]
  alb_zone_id           = module.boxi_ec2_albs[each.key].lb_zone_id[0]
}
