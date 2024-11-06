
resource "aws_security_group" "this" {
  name        = module.service_access_security_group_tags.name
  description = "VPC Endpoint Security Group"
  vpc_id      = data.aws_vpc.default.id
  tags        = module.service_access_security_group_tags.tags

  ingress {
    description = "VPC Endpoint Security Group"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = var.cidr_blocks
  }
}

resource "aws_vpc_endpoint" "sagemaker_studio" {
  vpc_id              = data.aws_vpc.default.id
  service_name        = "aws.sagemaker.${data.aws_region.current.name}.notebook"
  security_group_ids  = compact(concat(data.aws_security_groups.management.ids, [aws_security_group.this.id]))
  subnet_ids          = data.aws_subnets.subnets.ids
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = "true"

  tags = module.interface_endpoint_tag_label.tags
}

resource "aws_vpc_endpoint" "sagemaker" {
  vpc_id              = data.aws_vpc.default.id
  service_name        = "aws.sagemaker.${data.aws_region.current.name}.studio"
  security_group_ids  = compact(concat(data.aws_security_groups.management.ids, [aws_security_group.this.id]))
  subnet_ids          = data.aws_subnets.subnets.ids
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = "true"

  tags = module.interface_endpoint_tag_label.tags
}

