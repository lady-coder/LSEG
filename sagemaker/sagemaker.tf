resource "aws_sagemaker_domain" "studio" {
  domain_name = module.sagemaker_domain.name
  auth_mode   = "IAM"

  app_network_access_type = "VpcOnly"
  vpc_id                  = data.aws_vpc.default.id
  subnet_ids              = data.aws_subnets.subnets.ids

  tags = module.sagemaker_domain.tags

  default_user_settings {
    execution_role  = aws_iam_role.sagemaker_role.arn
    security_groups = compact(concat(data.aws_security_groups.management.ids)) //,["sg-09c8764a859df2f0f","sg-0efbe617d96fe6d52"]))

    kernel_gateway_app_settings {
      lifecycle_config_arns = [aws_sagemaker_studio_lifecycle_config.studio_lifecycle_config.arn]
    }

    sharing_settings {
      notebook_output_option = "Allowed"
      s3_output_path         = "s3://${aws_s3_bucket.sagemaker-s3.id}/"
    }
  }
}

resource "aws_sagemaker_user_profile" "user" {
  domain_id         = aws_sagemaker_domain.studio.id
  user_profile_name = module.sagemaker_user.name
  user_settings {
    execution_role = aws_iam_role.sagemaker_role.arn
    kernel_gateway_app_settings {
      lifecycle_config_arns = [aws_sagemaker_studio_lifecycle_config.studio_lifecycle_config.arn]
    }
  }
  tags = module.sagemaker_user.tags
}

resource "aws_sagemaker_domain" "studio_tenants" {
  for_each = toset(var.tenants)
  domain_name = module.sagemaker_tenants_domain[each.value].name
  auth_mode   = "IAM"

  app_network_access_type = "VpcOnly"
  vpc_id                  = data.aws_vpc.default.id
  subnet_ids              = data.aws_subnets.subnets.ids

  tags = module.sagemaker_tenants_domain[each.value].tags

  default_user_settings {
    execution_role  = aws_iam_role.sagemaker_role.arn
    security_groups = compact(concat(data.aws_security_groups.management.ids)) //,["sg-09c8764a859df2f0f","sg-0efbe617d96fe6d52"]))

    kernel_gateway_app_settings {
      lifecycle_config_arns = [aws_sagemaker_studio_lifecycle_config.studio_lifecycle_config.arn]
    }

    sharing_settings {
      notebook_output_option = "Allowed"
      s3_output_path         = "s3://${aws_s3_bucket.sagemaker-s3.id}/"
    }
  }
}

resource "aws_sagemaker_user_profile" "tenant_users" {
  for_each = toset(var.tenants)
  domain_id         = aws_sagemaker_domain.studio_tenants[each.value].id
  user_profile_name = module.sagemaker_user_tenants[each.value].name
  user_settings {
    execution_role = aws_iam_role.sagemaker_role.arn
    kernel_gateway_app_settings {
      lifecycle_config_arns = [aws_sagemaker_studio_lifecycle_config.studio_lifecycle_config.arn]
    }
  }
  tags = module.sagemaker_user_tenants[each.value].tags
}


resource "aws_iam_role" "sagemaker_role" {
  name                  = module.iam_sagemaker.name
  permissions_boundary  = data.aws_iam_policy.service_role_boundary.arn
  description           = "Allows SageMaker notebook instances, training jobs, and models to access S3, ECR, and CloudWatch on your behalf."
  force_detach_policies = false
  managed_policy_arns = [
    aws_iam_policy.sagemaker_core_1.arn,
    aws_iam_policy.sagemaker_core_2.arn,
    aws_iam_policy.sagemaker_core_3.arn,
    aws_iam_policy.sagemaker_s3_access.arn,
    aws_iam_policy.sagemaker_secrets_manager.arn
  ]
  assume_role_policy = jsonencode(
    {
      Statement = [
        {
          Action = "sts:AssumeRole"
          Effect = "Allow"
          Principal = {
            Service = "sagemaker.amazonaws.com"
          }
          Sid = ""
        },
      ]
      Version = "2012-10-17"
    }
  )
  max_session_duration = 3600
  path                 = "/"
  tags                 = module.iam_sagemaker.tags
}

resource "aws_sagemaker_studio_lifecycle_config" "studio_lifecycle_config" {
  studio_lifecycle_config_name = "${module.sagemaker_studio_lifecycle.name}-config"
  studio_lifecycle_config_app_type = "JupyterServer"
  studio_lifecycle_config_content = "${base64encode(<<EOF
  # This script configures proxy settings for your Jupyter Server and Kernel appliations
# This is useful for use cases where you would like to configure your notebook instance in your custom VPC
# without direct internet access to route all traffic via a proxy server in your VPC.

# Please ensure that you have already configure a proxy server in your VPC.

#!/bin/bash
 
set -eux

# PARAMETERS
PROXY_SERVER=http://proxy_${data.aws_vpc.default.id}:3128
# Please note that we are excluding S3 because we do not want this traffic to be routed over the public internet, but rather through the S3 endpoint in the VPC.
EXCLUDED_HOSTS=".r53,.local,.stockex.local,.privatelink.snowflakecomputing.com,169.254,172.16,100.64,10.192.0.0,192.168,10.,nexus.lseg.stockex.local,monitoring.eu-west-2.amazonaws.com,kms.eu-west-2.amazonaws.com,s3.eu-west-2.amazonaws.com,logs.eu-west-2.amazonaws.com,ec2messages.eu-west-2.amazonaws.com,ec2.eu-west-2.amazonaws.com,ssmmessages.eu-west-2.amazonaws.com,ssm.eu-west-2.amazonaws.com,sts.lseg.com,.dx1.lseg.com,.dx1.dev.lseg.com,.dx1.qa.lseg.com"

mkdir -p ~/.ipython/profile_default/startup/
touch ~/.ipython/profile_default/startup/00-startup.py

echo "export http_proxy='http://proxy_${data.aws_vpc.default.id}:3128'" | tee -a ~/.profile >/dev/null
echo "export https_proxy='http://proxy_${data.aws_vpc.default.id}:3128'" | tee -a ~/.profile >/dev/null
echo "export no_proxy='$EXCLUDED_HOSTS'" | tee -a ~/.profile >/dev/null

echo "import sys,os,os.path" | tee -a ~/.ipython/profile_default/startup/00-startup.py >/dev/null
echo "os.environ['HTTP_PROXY']="\""$PROXY_SERVER"\""" | tee -a ~/.ipython/profile_default/startup/00-startup.py >/dev/null
echo "os.environ['HTTPS_PROXY']="\""$PROXY_SERVER"\""" | tee -a ~/.ipython/profile_default/startup/00-startup.py >/dev/null
echo "os.environ['NO_PROXY']="\""$EXCLUDED_HOSTS"\""" | tee -a ~/.ipython/profile_default/startup/00-startup.py >/dev/null
  EOF

)}"
}

resource "aws_sagemaker_notebook_instance_lifecycle_configuration" "notebook_config" {
  name = "${module.sagemaker_notebook.name}-config"
  //on_start = filebase64("${path.module}/scripts/proxy-for-jupyter.sh")
  on_start = "${base64encode(<<EOF
  # This script configures proxy settings for your Jupyter notebooks and the SageMaker notebook instance.
# This is useful for use cases where you would like to configure your notebook instance in your custom VPC
# without direct internet access to route all traffic via a proxy server in your VPC.

# Please ensure that you have already configured a proxy server in your VPC.

#!/bin/bash
 
set -e

su - ec2-user -c "mkdir -p /home/ec2-user/.ipython/profile_default/startup/ && touch /home/ec2-user/.ipython/profile_default/startup/00-startup.py"

# Please replace proxy.local:3128 with the URL of your proxy server eg, proxy.example.com:80 or proxy.example.com:443
# Please note that we are excluding S3 because we do not want this traffic to be routed over the public internet, but rather through the S3 endpoint in the VPC.

#PARAMETER
SERVER=http://proxy_${data.aws_vpc.default.id}:3128

echo "export http_proxy=http://proxy_${data.aws_vpc.default.id}:3128" | tee -a /home/ec2-user/.profile >/dev/null
echo "export https_proxy=http://proxy_${data.aws_vpc.default.id}:3128" | tee -a /home/ec2-user/.profile >/dev/null
echo "export no_proxy='.r53,.local,.stockex.local,.privatelink.snowflakecomputing.com,169.254,172.16,100.64,10.192.0.0,192.168,10.,nexus.lseg.stockex.local,monitoring.eu-west-2.amazonaws.com,kms.eu-west-2.amazonaws.com,s3.eu-west-2.amazonaws.com,logs.eu-west-2.amazonaws.com,ec2messages.eu-west-2.amazonaws.com,ec2.eu-west-2.amazonaws.com,ssmmessages.eu-west-2.amazonaws.com,ssm.eu-west-2.amazonaws.com,sts.lseg.com,.dx1.lseg.com,.dx1.dev.lseg.com,.dx1.qa.lseg.com'" | tee -a /home/ec2-user/.profile >/dev/null

# Now we change the terminal shell to bash
echo "c.NotebookApp.terminado_settings={'shell_command': ['/bin/bash']}" | tee -a /home/ec2-user/.jupyter/jupyter_notebook_config.py >/dev/null

echo "import sys,os,os.path" | tee -a /home/ec2-user/.ipython/profile_default/startup/00-startup.py >/dev/null
echo "os.environ['HTTP_PROXY']=http://proxy_${data.aws_vpc.default.id}:3128" | tee -a /home/ec2-user/.ipython/profile_default/startup/00-startup.py >/dev/null
echo "os.environ['HTTPS_PROXY']=http://proxy_${data.aws_vpc.default.id}:3128" | tee -a /home/ec2-user/.ipython/profile_default/startup/00-startup.py >/dev/null
echo "os.environ['NO_PROXY']=.r53,.local,.stockex.local,.privatelink.snowflakecomputing.com,169.254,172.16,100.64,10.192.0.0,192.168,10.,nexus.lseg.stockex.local,monitoring.eu-west-2.amazonaws.com,kms.eu-west-2.amazonaws.com,s3.eu-west-2.amazonaws.com,logs.eu-west-2.amazonaws.com,ec2messages.eu-west-2.amazonaws.com,ec2.eu-west-2.amazonaws.com,ssmmessages.eu-west-2.amazonaws.com,ssm.eu-west-2.amazonaws.com,sts.lseg.com,.dx1.lseg.com,.dx1.dev.lseg.com,.dx1.qa.lseg.com" | tee -a /home/ec2-user/.ipython/profile_default/startup/00-startup.py >/dev/null

# Next, we reboot the system so the bash shell setting can take effect. This reboot is only required when applying proxy settings to the shell environment as well.
# If only setting up Jupyter notebook proxy, you can leave this out

#reboot
  EOF

)}"
}

resource "aws_sagemaker_notebook_instance" "notebook" {
  name                  = module.sagemaker_notebook.name
  role_arn              = aws_iam_role.sagemaker_role.arn
  instance_type         = "ml.t3.large"
  platform_identifier   = "notebook-al2-v2"
  volume_size           = 10
  root_access           = "Disabled"
  subnet_id             = element(data.aws_subnets.subnets.ids, 0)
  security_groups       = compact(concat(data.aws_security_groups.management.ids)) //["sg-09c8764a859df2f0f","sg-0efbe617d96fe6d52"]
  lifecycle_config_name = aws_sagemaker_notebook_instance_lifecycle_configuration.notebook_config.name
  tags                  = module.sagemaker_notebook.tags
}

resource "aws_sagemaker_notebook_instance" "tenant_notebooks" {
  for_each              = toset(var.tenants) 
  name                  = module.sagemaker_notebook_tenants[each.value].name
  role_arn              = aws_iam_role.sagemaker_role.arn
  instance_type         = "ml.t3.large"
  platform_identifier   = "notebook-al2-v2"
  volume_size           = 10
  root_access           = "Disabled"
  subnet_id             = element(data.aws_subnets.subnets.ids, 0)
  security_groups       = compact(concat(data.aws_security_groups.management.ids)) //["sg-09c8764a859df2f0f","sg-0efbe617d96fe6d52"]
  lifecycle_config_name = aws_sagemaker_notebook_instance_lifecycle_configuration.notebook_config.name
  tags                  = module.sagemaker_notebook_tenants[each.value].tags
}

