locals {
  lb_ec2_targets = {
    for id in data.aws_instances.targets.ids : "target-${id}" => { target_id : id, port : 8089 }
  }

}
