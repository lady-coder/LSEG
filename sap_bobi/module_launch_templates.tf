module "ec2_bobi_launch_template" {
  source = "git::ssh://git@bitbucket.unix.lch.com:7999/dsrcp/terraform-aws-module-ec2-asg.git//app/modules/launch_template"

  name = module.ec2_lt_label.name

  block_device_mappings = [
    {
      device_name  = "/dev/sda1"
      no_device    = false
      virtual_name = ""
      ebs = {
        delete_on_termination = true
        encrypted             = true
        kms_key_id            = data.aws_kms_key.infra.arn
        volume_size           = 100
        volume_type           = "gp3"
        snapshot_id           = ""
        iops                  = 3000
      }
    },
    {
      device_name  = "xvdb"
      no_device    = false
      virtual_name = ""
      ebs = {
        delete_on_termination = true
        encrypted             = true
        kms_key_id            = data.aws_kms_key.infra.arn
        volume_size           = 150
        volume_type           = "gp3"
        snapshot_id           = ""
        iops                  = 3000
      }
    }
  ]
  ebs_optimized                        = var.ebs_optimized
  disable_api_termination              = var.disable_api_termination
  image_id                             = data.aws_ami.internal_ami.image_id
  instance_initiated_shutdown_behavior = var.instance_initiated_shutdown_behavior
  instance_market_options              = var.instance_market_options
  instance_type                        = var.instance_type
  key_name                             = var.key_name
  user_data_base64                     = base64encode(local.user_data_base64)
  iam_instance_profile_name            = var.iam_instance_profile_name
  enable_monitoring                    = var.enable_monitoring
  associate_public_ip_address          = var.associate_public_ip_address
  subnet_id                            = data.aws_subnets.subnet-2a.ids[0]
  security_group_ids = flatten([
    data.aws_security_groups.management.ids,
    join("", aws_security_group.ec2_rds.*.id)
  ])
  tag_specifications_resource_types = var.tag_specifications_resource_types
  tags                              = module.ec2_lt_label.tags
}
