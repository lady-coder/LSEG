module "alb_cms" {
  source = "git::ssh://git@bitbucket.unix.lch.com:7999/dsrcp/terraform-aws-module-alb.git//app/modules/alb"

  name = var.alb_name

  security_groups = var.alb_security_groups

  subnets = data.aws_subnets.private.ids
  vpc_id  = data.aws_vpc.default.id

  load_balancer_type = "application"
  internal           = true

  https_listeners    = [
    {
      port              = 443
      certificate_arn   = var.boxi_cert_domain
      ssl_policy        = "ELBSecurityPolicy-TLS-1-2-Ext-2018-06"
    }

  ]

  target_groups = [
    {
      name_prefix          = "boxi"
      backend_port         = 8080
      backend_protocol     = "HTTP"
      target_type          = "instance"
      deregistration_delay = 10
      health_check = {
        enabled             = true
        interval            = 300
        path                = "/"
        port                = "traffic-port"
        healthy_threshold   = 3
        unhealthy_threshold = 3
        protocol            = "HTTP"
        matcher             = "200-300"
      }
      protocol_version = "HTTP1"
      targets          = local.lb_ec2_targets
      stickiness = {
        enabled         = true
        type            = "lb_cookie"
        cookie_duration = 86400
      }
    },
  ]

  /* http_tcp_listener_rules = [
    {
      http_tcp_listener_index = 0
      
    }
  ] */

  tags = var.tags
}





