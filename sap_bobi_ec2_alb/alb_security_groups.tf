resource "aws_security_group" "bo_lbs" {
  name        = module.sg_lb_cms_label.name
  description = "Allow inbound traffic to CMS nodes from LB"
  vpc_id      = data.aws_vpc.default.id
  tags        = module.sg_lb_cms_label.tags

  ingress {
    description = ""
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.cidr_blocks
  }
  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = var.cidr_blocks
  }
   egress {
    description = "BOXI"
    from_port   = 8089
    to_port     = 8089
    protocol    = "tcp"
    cidr_blocks = var.cidr_blocks
  }
  

  egress {
    description     = "CMS"
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    cidr_blocks = var.cidr_blocks
  }
}
