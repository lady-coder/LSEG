resource "aws_security_group" "ec2_rds" {
  count = module.this.enabled ? 1 : 0

  name        = module.sg_ec2_label.name
  description = "Allow inbound traffic from the security groups"
  vpc_id      = data.aws_vpc.default.id
  tags        = module.sg_ec2_label.tags
}

