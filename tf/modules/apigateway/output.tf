output "apigateway_arn" {
  value = aws_api_gateway_rest_api.apiLambda_private.arn
}
output "apigateway_id" {
  value = aws_api_gateway_rest_api.apiLambda_private.id
}

output "apigateway_execution_arn" {
  value = aws_api_gateway_rest_api.apiLambda_private.execution_arn
}

output "apigateway_invoke_url" {
  value = aws_api_gateway_stage.apiStage.invoke_url
}
output "apigateway_rest_api_id" {
  value = aws_api_gateway_stage.apiStage.rest_api_id
}

output "apigateway_deploy_id" {
  value = aws_api_gateway_deployment.apideploy.id
}

output "regional_domain_name" {
  value = aws_api_gateway_domain_name.custom_name.regional_domain_name
}
output "regional_zone_id" {
  value = aws_api_gateway_domain_name.custom_name.regional_zone_id
}
