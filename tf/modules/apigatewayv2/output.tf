output "apigateway_arn" {
  value = aws_apigatewayv2_api.apiLambda_private.arn
}

output "apigateway_id" {
  value = aws_apigatewayv2_api.apiLambda_private.id
}

output "apigateway_execution_arn" {
  value = aws_apigatewayv2_api.apiLambda_private.execution_arn
}

output "apigateway_invoke_url" {
  value = aws_apigatewayv2_stage.stage_name.invoke_url
}

output "apigateway_api_id" {
  value = aws_apigatewayv2_stage.stage_name.id
}

output "regional_domain_name" {
  value = aws_apigatewayv2_domain_name.custom_name.domain_name_configuration[0].target_domain_name
}
output "regional_zone_id" {
  value = aws_apigatewayv2_domain_name.custom_name.domain_name_configuration[0].hosted_zone_id
}
