resource "aws_route53_record" "boxi_records" {
  zone_id = data.aws_route53_zone.r53.zone_id
  name    = "${var.r53_record_name}.${data.aws_route53_zone.r53.name}"
  type    = "A"
  alias {
    name                   = var.alb_dns_name
    zone_id                = var.alb_zone_id
    evaluate_target_health = true
  }
}