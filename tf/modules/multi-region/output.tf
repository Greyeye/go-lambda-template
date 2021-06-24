output "random_id" {
  value = random_id.server.id
}
output "random_hex" {
  value = random_id.server.hex
}

output "regional_host_name"  {
  value = module.api.regional_domain_name
}

output "apigw_host_name" {
  value = "${module.api.apigateway_rest_api_id}.execute-api.${var.aws_region}.amazonaws.com"
}

output "apigw_zone_id" {
  value = module.api.regional_zone_id
}
