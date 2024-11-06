module "oracle_master_secret" {
  source = "git::ssh://bitbucket.unix.lch.com:7999/dsrcp/terraform-aws-module-secrets.git//app/modules/secretsmanager?ref=v0.2.0"

  environment      = var.environment
  business_unit    = var.business_unit
  region           = var.region
  application_name = var.application_name
  application_id   = var.application_id
  cost_centre      = var.cost_centre
  managed_by       = var.managed_by
  project_code     = var.project_code
  code_repo        = var.code_repo

  postfix_names = concat(local.additional_names, ["database", "oracle", "superuser"])
  secret_string = jsonencode({
    password = var.db_master_secret
  })
  recovery_window_in_days = var.secret_recovery_window_in_days
}

module "fsx_ad_secret" {
  source = "git::ssh://bitbucket.unix.lch.com:7999/dsrcp/terraform-aws-module-secrets.git//app/modules/secretsmanager?ref=v0.2.0"

  environment      = var.environment
  business_unit    = var.business_unit
  region           = var.region
  application_name = var.application_name
  application_id   = var.application_id
  cost_centre      = var.cost_centre
  managed_by       = var.managed_by
  project_code     = var.project_code
  code_repo        = var.code_repo

  postfix_names = concat(local.additional_names, ["windows", "share", "superuser"])
  secret_string = jsonencode({
    dnsIps            = var.fsx_self_managed_active_directory.dns_ips
    username          = var.fsx_self_managed_active_directory.username
    netbiosDomain     = var.fsx_self_managed_active_directory.netbios_domain
    domainName        = var.fsx_self_managed_active_directory.domain_name
    distinguishedName = var.fsx_self_managed_active_directory.organizational_unit_distinguished_name
    password          = var.fsx_self_managed_active_directory.password
    adAdminGroup      = lookup(var.fsx_self_managed_active_directory, "file_system_administrators_group", null)
  })

  recovery_window_in_days = var.secret_recovery_window_in_days
}




module "fsx_dns_name_secret" {
  depends_on = [
    module.windows_file_system
  ]
  source                = "git::ssh://bitbucket.unix.lch.com:7999/dsrcp/terraform-aws-module-secrets.git//app/modules/secretsmanager?ref=v0.2.0"
  environment           = var.environment
  business_unit         = var.business_unit
  region                = var.region
  application_name      = var.application_name
  application_id        = var.application_id
  cost_centre           = var.cost_centre
  managed_by            = var.managed_by
  project_code          = var.project_code
  code_repo             = var.code_repo
  postfix_names         = concat(local.additional_names, ["windows", "share", "dnsname"])
  secret_string         = jsonencode({
    fsxDnsName          = var.fsxDnsName
  })
  recovery_window_in_days = var.secret_recovery_window_in_days
}