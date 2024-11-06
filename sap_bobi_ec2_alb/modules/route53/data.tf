data "aws_route53_zone" "r53" {
  name = var.hosted_zone_name

  private_zone = true
}
