resource "aws_route53_record" "useast1" {
  zone_id = var.route53_zone_id
  name    = "api"
  type    = "A"

  alias {
    name                   = var.regional_host_name
    zone_id                = var.apigw_zone_id
    evaluate_target_health = false
  }
  health_check_id = var.healthcheckid
  set_identifier = "failover"
  failover_routing_policy {
    type = var.healthcheckpriority
  }
}
