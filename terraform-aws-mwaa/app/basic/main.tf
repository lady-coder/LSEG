#####################################################################################
# Terraform module examples are meant to show an _example_ on how to use a module
# per use-case. The code below should not be copied directly but referenced in order
# to build your own root module that invokes this module
#####################################################################################

data "aws_availability_zones" "available" {}

locals {
  azs = slice(data.aws_availability_zones.available.names, 0, 2)
  //bucket_name = "mwaa-bo-s3"//format("%s-%s", "aws-ia-mwaa", data.aws_caller_identity.current.account_id)
}

#-----------------------------------------------------------
# Create an S3 bucket and upload sample DAG
#-----------------------------------------------------------
#tfsec:ignore:AWS017 tfsec:ignore:AWS002 tfsec:ignore:AWS077
resource "aws_s3_bucket" "this" {
  bucket = module.s3_tags.name
  tags   = module.s3_tags.tags
}

resource "aws_s3_bucket_acl" "this" {
  bucket = aws_s3_bucket.this.id
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.this.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  bucket = aws_s3_bucket.this.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "this" {
  bucket                  = aws_s3_bucket.this.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Upload DAGS
resource "aws_s3_object" "object1" {
  for_each = fileset("dags/", "*")
  bucket   = aws_s3_bucket.this.id
  key      = "dags/${each.key}"
  source   = "dags/${each.key}"
  etag     = filemd5("dags/${each.key}")
}

# Upload plugins/requirements.txt
resource "aws_s3_object" "reqs" {
  for_each = fileset("mwaa/", "*")
  bucket   = aws_s3_bucket.this.id
  key      = each.key
  source   = "mwaa/${each.key}"
  etag     = filemd5("mwaa/${each.key}")
}
/**
resource "aws_secretsmanager_secret" "snowflake_secrets_mwaa" {
  name = module.secrets_label_mwaa.name
  tags = module.secrets_label_mwaa.tags
}**/
#-----------------------------------------------------------
# NOTE: MWAA Airflow environment takes minimum of 20 mins
#-----------------------------------------------------------
module "mwaa" {
  source = "../.."
  count             = var.create_generic_mwaa ? 1 : 0
  name              = module.mwaa_tags.name
  airflow_version   = "2.4.3"
  environment_class = "mw1.medium"
  create_s3_bucket  = false
  source_bucket_arn = aws_s3_bucket.this.arn
  dag_s3_path       = "dags"
  //iam_role_name     = module.iam_mwaa.name//"${var.name}"
  management_security_group = data.aws_security_groups.management.ids
  ## If uploading requirements.txt or plugins, you can enable these via these options
  #plugins_s3_path      = "plugins.zip"
  requirements_s3_path = "requirements.txt"

  logging_configuration = {
    dag_processing_logs = {
      enabled   = true
      log_level = "INFO"
    }

    scheduler_logs = {
      enabled   = true
      log_level = "INFO"
    }

    task_logs = {
      enabled   = true
      log_level = "INFO"
    }

    webserver_logs = {
      enabled   = true
      log_level = "INFO"
    }

    worker_logs = {
      enabled   = true
      log_level = "INFO"
    }
  }

  airflow_configuration_options = {
    "core.load_default_connections" = "false"
    "core.load_examples"            = "false"
    "webserver.dag_default_view"    = "tree"
    "webserver.dag_orientation"     = "TB"
    "secrets.backend"               = "airflow.providers.amazon.aws.secrets.secrets_manager.SecretsManagerBackend"
    "secrets.backend_kwargs"        = jsonencode({ "connections_prefix" : "airflow/connections", "variables_prefix" : "airflow/variables" })

  }

  min_workers        = 1
  max_workers        = 2
  vpc_id             = data.aws_vpc.vpclookup[each.value.vpc].id                      //module.vpc.vpc_id
  private_subnet_ids = slice(data.aws_subnets.subnetlookups[each.value.vpc].ids, 0, 2) //module.vpc.private_subnets

  webserver_access_mode = "PUBLIC_ONLY"  # Choose the Private network option(PRIVATE_ONLY) if your Apache Airflow UI is only accessed within a corporate network, and you do not require access to public repositories for web server requirements installation
  source_cidr           = ["10.0.0.0/8"] # Add your IP address to access Airflow UI

  tags = module.mwaa_tags.tags

}

#---------------------------------------------------------------
# Tenant MWAA env Resources
#---------------------------------------------------------------
module "tenants_mwaa" {
  source            = "../.."
 
  for_each          = {for kv in local.tenant_map : kv.name => kv}
  name              = module.mwaa_env_tags[each.key].name
  airflow_version   = "2.4.3"
  environment_class = "mw1.medium"
  create_s3_bucket  = false
  source_bucket_arn = aws_s3_bucket.tenant[each.key].arn
  dag_s3_path       = "dags"
  //iam_role_name     = module.iam_mwaa.name//"${var.name}"
  management_security_group = data.aws_security_groups.vpcmanagement[each.value.vpc].ids
  ## If uploading requirements.txt or plugins, you can enable these via these options
  #plugins_s3_path      = "plugins.zip"
  requirements_s3_path = "requirements.txt"

  logging_configuration = {
    dag_processing_logs = {
      enabled   = true
      log_level = "INFO"
    }

    scheduler_logs = {
      enabled   = true
      log_level = "INFO"
    }

    task_logs = {
      enabled   = true
      log_level = "INFO"
    }

    webserver_logs = {
      enabled   = true
      log_level = "INFO"
    }

    worker_logs = {
      enabled   = true
      log_level = "INFO"
    }
  }

  airflow_configuration_options = {
    "core.load_default_connections" = "false"
    "core.load_examples"            = "false"
    "webserver.dag_default_view"    = "tree"
    "webserver.dag_orientation"     = "TB"
    "secrets.backend"               = "airflow.providers.amazon.aws.secrets.secrets_manager.SecretsManagerBackend"
    "secrets.backend_kwargs"        = jsonencode({ "connections_prefix" : "airflow/connections", "variables_prefix" : "airflow/variables" })

  }

  min_workers        = 1
  max_workers        = 2
  vpc_id             = data.aws_vpc.vpclookup[each.value.vpc].id//data.aws_vpc.this.id                      //module.vpc.vpc_id
  private_subnet_ids = slice(data.aws_subnets.subnetlookups[each.value.vpc].ids, 0, 2) //module.vpc.private_subnets

  webserver_access_mode = "PUBLIC_ONLY"  # Choose the Private network option(PRIVATE_ONLY) if your Apache Airflow UI is only accessed within a corporate network, and you do not require access to public repositories for web server requirements installation
  source_cidr           = ["10.0.0.0/8"] # Add your IP address to access Airflow UI

  tags = module.mwaa_env_tags[each.key].tags

}
/**
resource "aws_secretsmanager_secret" "snowflake_secrets" {
  for_each = {for kv in local.tenant_map : kv.name => kv}
  name     = module.secrets_label[each.key].name
  tags     = module.secrets_label[each.key].tags
}
**/

resource "aws_s3_bucket" "tenant" {
  for_each = {for kv in local.tenant_map : kv.name => kv}
  bucket   = module.s3_env_tags[each.key].name
  tags     = module.s3_env_tags[each.key].tags
}

resource "aws_s3_bucket_acl" "tenant" {
  for_each = {for kv in local.tenant_map : kv.name => kv}
  bucket   = aws_s3_bucket.tenant[each.key].id
  acl      = "private"
}

resource "aws_s3_bucket_versioning" "tenant" {
  for_each = {for kv in local.tenant_map : kv.name => kv}
  bucket   = aws_s3_bucket.tenant[each.key].id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "tenant" {
  for_each = {for kv in local.tenant_map : kv.name => kv}
  bucket   = aws_s3_bucket.tenant[each.key].id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "tenant" {
  for_each                = {for kv in local.tenant_map : kv.name => kv}
  bucket                  = aws_s3_bucket.tenant[each.key].id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}


module "env_s3_file_upload" {

  source    = "../../file_module"
  for_each  = {for kv in local.tenant_map : kv.name => kv}
  bucket_id = aws_s3_bucket.tenant[each.key].id

}

/***
data "aws_iam_role" "attach_to_ingress_role" {
  name = "lch-sno-poc-sagemaker-adfs-role"
  //permissions_boundary  = data.aws_iam_policy.service_role_boundary.arn
}

resource "aws_iam_role_policy_attachment" "mwaa_adfs_attach" {
  for_each    = {for kv in local.tenant_map : kv.name => kv}
  policy_arn = aws_iam_policy.mwaa_adfs_role_policy[each.key].arn
  role       = data.aws_iam_role.attach_to_ingress_role.id
}

resource "aws_iam_policy" "mwaa_adfs_role_policy" {
  for_each    = {for kv in local.tenant_map : kv.name => kv}
  name        = join("-", [module.mwaa_env_tags[each.key].name], ["policy"])
  description = "ADFS mwaa policy for tenants"
  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"
        Action = [
          "airflow:*"
        ]
        Resource = [
          "arn:${data.aws_partition.this.id}:airflow:${data.aws_region.this.name}:${data.aws_caller_identity.this.account_id}:environment/${module.mwaa_env_tags[each.key].name}"
        ]
      }
      , {
        Effect = "Allow"
        Action = [
          "s3:*"
        ]
        Resource = [
          "*"
        ]
      }

      , {
        Effect = "Allow"
        Action = [
          "logs:CreateLogStream",
          "logs:CreateLogGroup",
          "logs:PutLogEvents",
          "logs:GetLogEvents",
          "logs:GetLogRecord",
          "logs:GetLogGroupFields",
          "logs:GetQueryResults"
        ]
        Resource = [
          "arn:${data.aws_partition.this.id}:logs:${data.aws_region.this.name}:${data.aws_caller_identity.this.account_id}:log-group:airflow-${module.mwaa_env_tags[each.key].name}-*"
        ]
      }

      , {
        Effect = "Allow"
        Action = [
          "logs:DescribeLogGroups",
          "cloudwatch:PutMetricData",
          "batch:DescribeJobs",
          "batch:ListJobs",
          "eks:*"
        ]
        Resource = [
          "*"
        ]
      }
      , {
        Effect = "Allow"
        Action = [
          "sqs:ChangeMessageVisibility",
          "sqs:DeleteMessage",
          "sqs:GetQueueAttributes",
          "sqs:GetQueueUrl",
          "sqs:ReceiveMessage",
          "sqs:SendMessage"
        ]
        Resource = [
          "arn:${data.aws_partition.this.id}:sqs:${data.aws_region.this.name}:*:airflow-celery-*"
        ]
      }

      , {
        Effect = "Allow"
        Action = [
          "kms:Decrypt",
          "kms:DescribeKey",
          "kms:GenerateDataKey*",
          "kms:Encrypt"
        ]
        Resource = ["*"]
      }

      , {
        Effect = "Allow"
        Action = [
          "batch:*",
        ]
        Resource = [
          "arn:${data.aws_partition.this.id}:batch:*:${data.aws_caller_identity.this.account_id}:*"
        ]
      }

      , {
        Effect = "Allow"
        Action = [
          "ssm:*"
        ]
        Resource = [
          "arn:${data.aws_partition.this.id}:ssm:${data.aws_region.this.name}:${data.aws_caller_identity.this.account_id}:parameter/*"
        ]
      }

      , {
        Effect = "Allow"
        Action = [
          "logs:*"
        ]
        Resource = ["arn:${data.aws_partition.this.id}:logs:${data.aws_region.this.name}:${data.aws_caller_identity.this.account_id}:log-group:/aws/lambda/*"]
      }

      , {
        Effect   = "Allow"
        Action   = ["cloudwatch:*"]
        Resource = ["arn:${data.aws_partition.this.id}:logs:${data.aws_region.this.name}:${data.aws_caller_identity.this.account_id}:log-group:/aws/lambda/*"]
      }

      , {
        Effect = "Allow"
        Action = [
          "secretsmanager:GetResourcePolicy",
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret",
          "secretsmanager:ListSecretVersionIds"
        ]
        Resource = ["arn:${data.aws_partition.this.id}:secretsmanager:${data.aws_region.this.name}:${data.aws_caller_identity.this.account_id}:secret:*"]
      }

      , {
        Effect   = "Allow"
        Action   = ["secretsmanager:ListSecrets"]
        Resource = ["*"]
      },
    ]
  })

}
**/