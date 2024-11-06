module "windows_file_system" {
  source = "git::ssh://git@bitbucket.unix.lch.com:7999/dsrcp/terraform-aws-module-fsx-windows-fs.git//app/modules/windows_file_system?ref=v1.1.3"

  enabled          = var.fsx_enabled
  environment      = var.environment
  business_unit    = var.business_unit
  region           = var.region
  application_name = var.application_name
  application_id   = var.application_id
  cost_centre      = var.cost_centre
  managed_by       = var.managed_by
  project_code     = var.project_code
  code_repo        = var.code_repo
  additional_names = local.additional_names

  storage_capacity    = var.fsx_storage_capacity
  subnet_ids          = local.multiaz_subnets_ids
  throughput_capacity = var.fsx_throughput_capacity
  deployment_type     = "MULTI_AZ_1"
  preferred_subnet_id = local.preferred_subnet_id
  storage_type        = "SSD"
  vpc_id              = data.aws_vpc.default.id
  security_group_ids  = var.fsx_security_group_ids
  cidr_blocks         = var.cidr_blocks
  self_managed_active_directory = {
    dns_ips                                = jsondecode(data.aws_secretsmanager_secret_version.windows-share.secret_string)["dnsIps"]
    domain_name                            = jsondecode(data.aws_secretsmanager_secret_version.windows-share.secret_string)["domainName"]
    password                               = jsondecode(data.aws_secretsmanager_secret_version.windows-share.secret_string)["password"]
    username                               = jsondecode(data.aws_secretsmanager_secret_version.windows-share.secret_string)["username"]
    organizational_unit_distinguished_name = jsondecode(data.aws_secretsmanager_secret_version.windows-share.secret_string)["distinguishedName"]
    file_system_administrators_group       = null
  }
  depends_on = [
    module.fsx_ad_secret
  ]
}