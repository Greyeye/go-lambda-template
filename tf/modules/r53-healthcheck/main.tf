resource "aws_route53_health_check" "checker" {
  fqdn              = var.apigw_host_name
  port              = 443
  type              = "HTTPS"
  resource_path     = "${var.environment}/check"
  failure_threshold = "5"
  request_interval  = "30"

  tags = {
    Name = "${var.apigw_host_name}-health-check-${var.environment}-${var.deploymentID}"
    terraform = true
    deploymentID = var.deploymentID
  }
  regions = var.health_check_regions
}
