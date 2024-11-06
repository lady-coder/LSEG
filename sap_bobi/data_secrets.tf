data "aws_secretsmanager_secret" "oracle-superuser" {
  arn = module.oracle_master_secret.arn
}

data "aws_secretsmanager_secret_version" "oracle-superuser" {
  secret_id = data.aws_secretsmanager_secret.oracle-superuser.id
}


data "aws_secretsmanager_secret" "windows-share" {
  arn = module.fsx_ad_secret.arn
}

data "aws_secretsmanager_secret_version" "windows-share" {
  secret_id = data.aws_secretsmanager_secret.windows-share.id
}