################################################################################
# RDS Module
################################################################################

module "db_oracle" {
  source = "git::ssh://git@bitbucket.unix.lch.com:7999/dsrcp/terraform-aws-module-rds.git//app/modules/rds?ref=v0.1.3"

  environment      = var.environment
  application_name = var.application_name
  application_id   = var.application_id
  business_unit    = var.business_unit
  cost_centre      = var.cost_centre
  code_repo        = var.code_repo

  additional_names = local.additional_names

  vpc_id               = data.aws_vpc.default.id
  engine               = var.db_engine
  engine_version       = var.db_engine_version
  family               = var.db_parameter_group_family # DB parameter group
  major_engine_version = var.db_major_engine_version   # DB option group
  instance_class       = var.db_instance_class
  license_model        = "bring-your-own-license"

  database_port     = 1521
  storage_encrypted = var.storage_encrypted
  kms_key_id        = data.aws_kms_key.db_kms.arn
  create_db_option_group = false

  # Make sure that database name is capitalized, otherwise RDS will try to recreate RDS instance every time
  name                   = upper(var.db_name)
  username               = var.db_master_username
  password               = jsondecode(data.aws_secretsmanager_secret_version.oracle-superuser.secret_string)["password"]
  create_random_password = true
  random_password_length = 12
  port                   = 1521
  security_group_ids = flatten([
    aws_security_group.ec2_rds.*.id //, data.aws_security_group.ec2_multi.*.id
  ])

  allowed_cidr_blocks = var.allowed_cidr_blocks

  multi_az   = true
  subnet_ids = local.multiaz_subnets_ids
  /* vpc_security_group_ids = [module.security_group.security_group_id] */

  maintenance_window              = "Mon:00:00-Mon:03:00"
  backup_window                   = "03:00-06:00"
  enabled_cloudwatch_logs_exports = ["alert", "audit"]
  apply_immediately       = true
  backup_retention_period = 7
  skip_final_snapshot     = true
  deletion_protection     = false

  performance_insights_enabled          = true
  performance_insights_retention_period = 7
  create_monitoring_role                = true

  allocated_storage     = var.db_allocated_storage
  max_allocated_storage = var.db_max_allocated_storage

  # See here for support character sets https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Appendix.OracleCharacterSets.html
  character_set_name = "AL32UTF8"
}

data "aws_kms_key" "db_kms" {
  key_id = "alias/${var.db_kms_key}"
}