resource "aws_iam_policy" "sagemaker_core_1" {
  name        = module.iam_policy_sagemaker_core_1.name
  description = "Sagemaker Studio Core Permission Set 1"
  policy = jsonencode(
    {
      Statement = [
        {
          Action = [
            "sagemaker:*",
          ]
          Effect = "Allow"
          NotResource = [
            "arn:aws:sagemaker:*:*:domain/*",
            "arn:aws:sagemaker:*:*:user-profile/*",
            "arn:aws:sagemaker:*:*:app/*",
            "arn:aws:sagemaker:*:*:flow-definition/*",
          ]
          Sid = ""
        },
        {
          Action = [
            "sagemaker:CreatePresignedDomainUrl",
            "sagemaker:DescribeDomain",
            "sagemaker:ListDomains",
            "sagemaker:DescribeUserProfile",
            "sagemaker:ListUserProfiles",
            "sagemaker:*App",
            "sagemaker:ListApps",
          ]
          Effect   = "Allow"
          Resource = "*"
          Sid      = ""
        },
        {
          Action = "sagemaker:*"
          Condition = {
            StringEqualsIfExists = {
              "sagemaker:WorkteamType" = [
                "private-crowd",
                "vendor-crowd",
              ]
            }
          }
          Effect = "Allow"
          Resource = [
            "arn:aws:sagemaker:*:*:flow-definition/*",
          ]
          Sid = ""
        },
        {
          Action = [
            "application-autoscaling:DeleteScalingPolicy",
            "application-autoscaling:DeleteScheduledAction",
            "application-autoscaling:DeregisterScalableTarget",
            "application-autoscaling:DescribeScalableTargets",
            "application-autoscaling:DescribeScalingActivities",
            "application-autoscaling:DescribeScalingPolicies",
            "application-autoscaling:DescribeScheduledActions",
            "application-autoscaling:PutScalingPolicy",
            "application-autoscaling:PutScheduledAction",
            "application-autoscaling:RegisterScalableTarget",
            "aws-marketplace:ViewSubscriptions",
            "cloudformation:GetTemplateSummary",
            "cloudwatch:DeleteAlarms",
            "cloudwatch:DescribeAlarms",
            "cloudwatch:GetMetricData",
            "cloudwatch:GetMetricStatistics",
            "cloudwatch:ListMetrics",
            "cloudwatch:PutMetricAlarm",
            "cloudwatch:PutMetricData",
            "codecommit:BatchGetRepositories",
            "codecommit:CreateRepository",
            "codecommit:GetRepository",
            "codecommit:List*",
            "cognito-idp:AdminAddUserToGroup",
            "cognito-idp:AdminCreateUser",
            "cognito-idp:AdminDeleteUser",
            "cognito-idp:AdminDisableUser",
            "cognito-idp:AdminEnableUser",
            "cognito-idp:AdminRemoveUserFromGroup",
            "cognito-idp:CreateGroup",
            "cognito-idp:CreateUserPool",
            "cognito-idp:CreateUserPoolClient",
            "cognito-idp:CreateUserPoolDomain",
            "cognito-idp:DescribeUserPool",
            "cognito-idp:DescribeUserPoolClient",
            "cognito-idp:List*",
            "cognito-idp:UpdateUserPool",
            "cognito-idp:UpdateUserPoolClient",
            "ec2:CreateNetworkInterface",
            "ec2:CreateNetworkInterfacePermission",
            "ec2:CreateVpcEndpoint",
            "ec2:DeleteNetworkInterface",
            "ec2:DeleteNetworkInterfacePermission",
            "ec2:DescribeDhcpOptions",
            "ec2:DescribeNetworkInterfaces",
            "ec2:DescribeRouteTables",
            "ec2:DescribeSecurityGroups",
            "ec2:DescribeSubnets",
            "ec2:DescribeVpcEndpoints",
            "ec2:DescribeVpcs",
            "ecr:BatchCheckLayerAvailability",
            "ecr:BatchGetImage",
            "ecr:CreateRepository",
            "ecr:Describe*",
            "ecr:GetAuthorizationToken",
            "ecr:GetDownloadUrlForLayer",
            "ecr:StartImageScan",
            "elastic-inference:Connect",
            "elasticfilesystem:DescribeFileSystems",
            "elasticfilesystem:DescribeMountTargets",
            "fsx:DescribeFileSystems",
            "glue:CreateJob",
            "glue:DeleteJob",
            "glue:GetJob*",
            "glue:GetTable*",
            "glue:GetWorkflowRun",
            "glue:ResetJobBookmark",
            "glue:StartJobRun",
            "glue:StartWorkflowRun",
            "glue:UpdateJob",
            "groundtruthlabeling:*",
            "iam:ListRoles",
            "kms:DescribeKey",
            "kms:ListAliases",
            "lambda:ListFunctions",
            "logs:CreateLogDelivery",
            "logs:CreateLogGroup",
            "logs:CreateLogStream",
            "logs:DeleteLogDelivery",
            "logs:Describe*",
            "logs:GetLogDelivery",
            "logs:GetLogEvents",
            "logs:ListLogDeliveries",
            "logs:PutLogEvents",
            "logs:PutResourcePolicy",
            "logs:UpdateLogDelivery",
            "robomaker:CreateSimulationApplication",
            "robomaker:DescribeSimulationApplication",
            "robomaker:DeleteSimulationApplication",
            "robomaker:CreateSimulationJob",
            "robomaker:DescribeSimulationJob",
            "robomaker:CancelSimulationJob",
            "secretsmanager:ListSecrets",
            "servicecatalog:Describe*",
            "servicecatalog:List*",
            "servicecatalog:ScanProvisionedProducts",
            "servicecatalog:SearchProducts",
            "servicecatalog:SearchProvisionedProducts",
            "sns:ListTopics",
            "tag:GetResources",
          ]
          Effect   = "Allow"
          Resource = "*"
          Sid      = ""
        },
      ]
      Version = "2012-10-17"
    }
  )
  tags = module.iam_policy_sagemaker_core_1.tags
}

resource "aws_iam_policy" "sagemaker_core_2" {
  name        = module.iam_policy_sagemaker_core_2.name
  description = "Sagemaker Studio Core Permission Set 2"
  policy = jsonencode(
    {
      Statement = [
        {
          Action = [
            "ecr:SetRepositoryPolicy",
            "ecr:CompleteLayerUpload",
            "ecr:BatchDeleteImage",
            "ecr:UploadLayerPart",
            "ecr:DeleteRepositoryPolicy",
            "ecr:InitiateLayerUpload",
            "ecr:DeleteRepository",
            "ecr:PutImage",
          ]
          Effect = "Allow"
          Resource = [
            "arn:aws:ecr:*:*:repository/*sagemaker*",
          ]
          Sid = ""
        },
        {
          Action = [
            "codecommit:GitPull",
            "codecommit:GitPush",
          ]
          Effect = "Allow"
          Resource = [
            "arn:aws:codecommit:*:*:*sagemaker*",
            "arn:aws:codecommit:*:*:*SageMaker*",
            "arn:aws:codecommit:*:*:*Sagemaker*",
          ]
          Sid = ""
        },
        {
          Action = [
            "codebuild:BatchGetBuilds",
            "codebuild:StartBuild",
          ]
          Effect = "Allow"
          Resource = [
            "arn:aws:codebuild:*:*:project/sagemaker*",
            "arn:aws:codebuild:*:*:build/*",
          ]
          Sid = ""
        },
        {
          Action = [
            "states:DescribeExecution",
            "states:GetExecutionHistory",
            "states:StartExecution",
            "states:StopExecution",
            "states:UpdateStateMachine",
          ]
          Effect = "Allow"
          Resource = [
            "arn:aws:states:*:*:statemachine:*sagemaker*",
            "arn:aws:states:*:*:execution:*sagemaker*:*",
          ]
          Sid = ""
        },
        {
          Action = [
            "secretsmanager:DescribeSecret",
            "secretsmanager:GetSecretValue",
            "secretsmanager:CreateSecret",
          ]
          Effect = "Allow"
          Resource = [
            "arn:aws:secretsmanager:*:*:secret:AmazonSageMaker-*",
          ]
          Sid = ""
        },
        {
          Action = [
            "secretsmanager:DescribeSecret",
            "secretsmanager:GetSecretValue",
          ]
          Condition = {
            StringEquals = {
              "secretsmanager:ResourceTag/SageMaker" = [
                "true",
              ]
            }
          }
          Effect   = "Allow"
          Resource = "*"
          Sid      = ""
        },
        {
          Action = [
            "servicecatalog:ProvisionProduct",
          ]
          Effect   = "Allow"
          Resource = "*"
          Sid      = ""
        },
        {
          Action = [
            "servicecatalog:TerminateProvisionedProduct",
            "servicecatalog:UpdateProvisionedProduct",
          ]
          Condition = {
            StringEquals = {
              "servicecatalog:userLevel" = [
                "self",
              ]
            }
          }
          Effect   = "Allow"
          Resource = "*"
          Sid      = ""
        },
        {
          Action = [
            "s3:GetObject",
            "s3:PutObject",
            "s3:DeleteObject",
            "s3:AbortMultipartUpload",
          ]
          Effect = "Allow"
          Resource = [
            "arn:aws:s3:::*SageMaker*",
            "arn:aws:s3:::*Sagemaker*",
            "arn:aws:s3:::*sagemaker*",
            "arn:aws:s3:::*aws-glue*",
          ]
          Sid = ""
        },
        {
          Action = [
            "s3:GetObject",
          ]
          Condition = {
            StringEqualsIgnoreCase = {
              "s3:ExistingObjectTag/SageMaker" = [
                "true",
              ]
            }
          }
          Effect   = "Allow"
          Resource = "*"
          Sid      = ""
        },
        {
          Action = [
            "s3:GetObject",
          ]
          Condition = {
            StringEquals = {
              "s3:ExistingObjectTag/servicecatalog:provisioning" = [
                "true",
              ]
            }
          }
          Effect   = "Allow"
          Resource = "*"
          Sid      = ""
        },
        {
          Action = [
            "s3:CreateBucket",
            "s3:GetBucketLocation",
            "s3:ListBucket",
            "s3:ListAllMyBuckets",
            "s3:GetBucketCors",
            "s3:PutBucketCors",
          ]
          Effect   = "Allow"
          Resource = "*"
          Sid      = ""
        },
        {
          Action = [
            "s3:GetBucketAcl",
            "s3:PutObjectAcl",
          ]
          Effect = "Allow"
          Resource = [
            "arn:aws:s3:::*SageMaker*",
            "arn:aws:s3:::*Sagemaker*",
            "arn:aws:s3:::*sagemaker*",
          ]
          Sid = ""
        },
        {
          Action = [
            "lambda:InvokeFunction",
          ]
          Effect = "Allow"
          Resource = [
            "arn:aws:lambda:*:*:function:*SageMaker*",
            "arn:aws:lambda:*:*:function:*sagemaker*",
            "arn:aws:lambda:*:*:function:*Sagemaker*",
            "arn:aws:lambda:*:*:function:*LabelingFunction*",
          ]
          Sid = ""
        },
      ]
      Version = "2012-10-17"
    }
  )
  tags = module.iam_policy_sagemaker_core_2.tags
}

resource "aws_iam_policy" "sagemaker_core_3" {
  name        = module.iam_policy_sagemaker_core_3.name
  description = "Sagemaker Studio Core Permission Set 3"
  policy = jsonencode(
    {
      Statement = [
        {
          Action = "iam:CreateServiceLinkedRole"
          Condition = {
            StringLike = {
              "iam:AWSServiceName" = [
                "sagemaker.application-autoscaling.amazonaws.com",
              ]
            }
          }
          Effect   = "Allow"
          Resource = "arn:aws:iam::*:role/aws-service-role/sagemaker.application-autoscaling.amazonaws.com/AWSServiceRoleForApplicationAutoScaling_SageMakerEndpoint"
          Sid      = ""
        },
        {
          Action = "iam:CreateServiceLinkedRole"
          Condition = {
            StringEquals = {
              "iam:AWSServiceName" = [
                "robomaker.amazonaws.com",
              ]
            }
          }
          Effect   = "Allow"
          Resource = "*"
          Sid      = ""
        },
        {
          Action = [
            "sns:Subscribe",
            "sns:CreateTopic",
          ]
          Effect = "Allow"
          Resource = [
            "arn:aws:sns:*:*:*SageMaker*",
            "arn:aws:sns:*:*:*Sagemaker*",
            "arn:aws:sns:*:*:*sagemaker*",
          ]
          Sid = ""
        },
        {
          Action = [
            "iam:PassRole",
          ]
          Condition = {
            StringEquals = {
              "iam:PassedToService" = [
                "glue.amazonaws.com",
                "robomaker.amazonaws.com",
                "states.amazonaws.com",
              ]
            }
          }
          Effect   = "Allow"
          Resource = "arn:aws:iam::*:role/*AmazonSageMaker*"
          Sid      = ""
        },
        {
          Action = [
            "iam:PassRole",
          ]
          Condition = {
            StringEquals = {
              "iam:PassedToService" = [
                "sagemaker.amazonaws.com",
              ]
            }
          }
          Effect   = "Allow"
          Resource = "arn:aws:iam::*:role/*"
          Sid      = ""
        },
        {
          Action = [
            "athena:ListDataCatalogs",
            "athena:ListDatabases",
            "athena:ListTableMetadata",
            "athena:GetQueryExecution",
            "athena:GetQueryResults",
            "athena:StartQueryExecution",
            "athena:StopQueryExecution",
          ]
          Effect = "Allow"
          Resource = [
            "*",
          ]
          Sid = ""
        },
        {
          Action = [
            "glue:CreateTable",
          ]
          Effect = "Allow"
          Resource = [
            "arn:aws:glue:*:*:table/*/sagemaker_tmp_*",
            "arn:aws:glue:*:*:table/sagemaker_featurestore/*",
            "arn:aws:glue:*:*:catalog",
            "arn:aws:glue:*:*:database/*",
          ]
          Sid = ""
        },
        {
          Action = [
            "glue:DeleteTable",
          ]
          Effect = "Allow"
          Resource = [
            "arn:aws:glue:*:*:table/*/sagemaker_tmp_*",
            "arn:aws:glue:*:*:catalog",
            "arn:aws:glue:*:*:database/*",
          ]
          Sid = ""
        },
        {
          Action = [
            "glue:GetDatabases",
            "glue:GetTable",
            "glue:GetTables",
          ]
          Effect = "Allow"
          Resource = [
            "arn:aws:glue:*:*:table/*",
            "arn:aws:glue:*:*:catalog",
            "arn:aws:glue:*:*:database/*",
          ]
          Sid = ""
        },
        {
          Action = [
            "glue:CreateDatabase",
            "glue:GetDatabase",
          ]
          Effect = "Allow"
          Resource = [
            "arn:aws:glue:*:*:catalog",
            "arn:aws:glue:*:*:database/sagemaker_featurestore",
            "arn:aws:glue:*:*:database/sagemaker_processing",
            "arn:aws:glue:*:*:database/default",
            "arn:aws:glue:*:*:database/sagemaker_data_wrangler",
          ]
          Sid = ""
        },
        {
          Action = [
            "redshift-data:ExecuteStatement",
            "redshift-data:DescribeStatement",
            "redshift-data:CancelStatement",
            "redshift-data:GetStatementResult",
            "redshift-data:ListSchemas",
            "redshift-data:ListTables",
          ]
          Effect = "Allow"
          Resource = [
            "*",
          ]
          Sid = ""
        },
        {
          Action = [
            "redshift:GetClusterCredentials",
          ]
          Effect = "Allow"
          Resource = [
            "arn:aws:redshift:*:*:dbuser:*/sagemaker_access*",
            "arn:aws:redshift:*:*:dbname:*",
          ]
          Sid = ""
        },
      ]
      Version = "2012-10-17"
    }
  )
  tags = module.iam_policy_sagemaker_core_3.tags
}