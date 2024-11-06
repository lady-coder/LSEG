module "boxi_server" {
  source = "git::ssh://git@bitbucket.unix.lch.com:7999/dsrcp/terraform-aws-module-ec2-instances.git//app/modules/ec2?ref=v0.5.2"
  count = var.boxi_environment_name.server

  region           = var.region
  environment      = var.environment
  business_unit    = var.business_unit
  application_name = var.application_name
  application_id   = var.application_id
  cost_centre      = var.cost_centre
  project_code     = var.project_code
  additional_names = concat(["boxi"], ["server"], [var.boxi_environment_name.env], [count.index])
  additional_tags = merge(tomap(
    {
      "Automation" : "UK_ALLDAYS_START_NOSNAPSHOT_CET",
      "BOXIEnvironment" : var.boxi_environment_name.env,
    "BOXIServerType" : "SERVER" }
  ), (tomap({"Tenant":var.tags.Tenant, "Service": var.tags.Service})))

  root_block_device = [
    {
      delete_on_termination = true
      encrypted             = true
      iops                  = 3000
      kms_key_id            = data.aws_kms_key.infra.arn
      volume_size           = 100
      volume_type           = "gp3"
      throughput            = 125
    }
  ]

  ebs_block_device = [
    {
      delete_on_termination = true
      device_name           = "xvdb"
      encrypted             = true
      iops                  = 3000
      kms_key_id            = data.aws_kms_key.infra.arn
      volume_size           = 150
      volume_type           = "gp3"
      throughput            = 125
    }
  ]

  subnet_id                            = count.index % 2 != 0 ? var.subnet_2a : var.subnet_2b // odd in 2a even in 2b - look at mod function */
  ami                                  = data.aws_ami.internal_ami.image_id
  key_name                             = var.key_name
  instance_type                        = var.instance_type
  ebs_optimized                        = var.ebs_optimized
  disable_api_termination              = var.disable_api_termination
  instance_initiated_shutdown_behavior = var.instance_initiated_shutdown_behavior
  #instance_market_options              = var.instance_market_options
  monitoring                  = var.enable_monitoring
  associate_public_ip_address = var.associate_public_ip_address
  vpc_security_group_ids = flatten([
    data.aws_security_groups.management.ids,
    #var.rds_security_groups,
    var.ec2_security_groups
  ])
  iam_instance_profile = data.aws_iam_instance_profile.insprofile
  user_data_base64     = base64encode(data.template_file.userdata_server.rendered)
  tags                 = var.tags
}

// resource "aws_volume_attachment" "device_1" {
//   count       = 4
//   device_name = "/dev/xvdz"
//   volume_id   = aws_ebs_volume.device_1_volume[count.index].id
//   instance_id = module.boxi_server[count.index].id
// }

// resource "aws_ebs_volume" "device_1_volume" {
//   count             = 4
//   availability_zone = count.index % 2 != 0 ? "${var.region}a" : "${var.region}b"
//   size              = 100
//   encrypted         = true
//   kms_key_id        = data.aws_kms_key.infra.arn
//   type              = "gp3"
//   snapshot_id       = ""
//   iops              = 3000

//   tags = var.tags

//   lifecycle {
//     ignore_changes = [
//       tags,
//       tags_all
//     ]
//   }
// }

// resource "aws_volume_attachment" "device_2" {
//   count       = 4
//   device_name = "xvdb"
//   volume_id   = aws_ebs_volume.device_2_volume[count.index].id
//   instance_id = module.boxi_server[count.index].id
// }

// resource "aws_ebs_volume" "device_2_volume" {
//   count             = 4
//   availability_zone = count.index % 2 != 0 ? "${var.region}a" : "${var.region}b"
//   size              = 150
//   encrypted         = true
//   kms_key_id        = data.aws_kms_key.infra.arn
//   type              = "gp3"
//   snapshot_id       = ""
//   iops              = 3000

//   tags = var.tags
//   lifecycle {
//     ignore_changes = [
//       tags,
//       tags_all
//     ]
//   }
// }