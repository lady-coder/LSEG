resource "aws_security_group" "boxi_ec2" {
  name        = module.sg_ec2_boxi_label.name
  description = "BOXI ec2 sg"
  vpc_id      = data.aws_vpc.default.id
  tags        = module.sg_ec2_boxi_label.tags

  ingress {
      description = "RDP"
      from_port   = 3389
      to_port     = 3389
      protocol    = "tcp"
      cidr_blocks = var.cidr_blocks
  }

  ingress {
    description     = "ALL Traffic ingress"
    from_port       = 0
    to_port         = 0
    protocol        = -1
    self            = true
  }

  egress {
    description = "SMTP"
    from_port   = 25
    to_port     = 25
    protocol    = "tcp"
    cidr_blocks = ["10.21.16.30/32", "10.124.125.30/32", "10.104.125.30/32", "10.210.160.24/32", "10.210.161.24/32"]
  }

  ingress {
    description     = "CMS"
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    cidr_blocks = var.cidr_blocks
  }

  ingress {
    description = "Flask API"
    from_port   = 8089
    to_port     = 8089
    protocol    = "tcp"
    cidr_blocks = var.cidr_blocks
  }

  egress {
    description     = "Callback API"
    from_port       = 8083
    to_port         = 8083
    protocol        = "tcp"
    cidr_blocks = var.cidr_blocks
  }

  egress {
    description     = "SMB"
    from_port       = 445
    to_port         = 445
    protocol        = "tcp"
    cidr_blocks = var.cidr_blocks
  }

  egress {
    description     = "FsX Admin Port"
    from_port       = 5985
    to_port         = 5985
    protocol        = "tcp"
    cidr_blocks = var.cidr_blocks
  }

  egress {
    description     = "HTTPS"
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    cidr_blocks = var.cidr_blocks
  }

  egress {
    description     = "HTTP"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    cidr_blocks = var.cidr_blocks
  }

  egress {
    description     = "ALL Traffic"
    from_port       = 0
    to_port         = 0
    protocol        = -1
    self            = true
  }

}
