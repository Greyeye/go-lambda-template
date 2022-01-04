resource "aws_apigatewayv2_api" "apiLambda_private" {
  name = "${var.apigateway_name}-${var.environment}-${var.deploymentID}"
  version       = "1.0.0"
  protocol_type = "HTTP"
  disable_execute_api_endpoint = false
  tags = var.tags
}

resource "aws_apigatewayv2_integration" "apiLambda_private" {
  api_id           = aws_apigatewayv2_api.apiLambda_private.id
  integration_type = "AWS_PROXY"
  connection_type        = "INTERNET"
  integration_method     = "POST"
  integration_uri        = var.target_lambda_invoke_arn
  payload_format_version = "1.0"
  timeout_milliseconds   = 30000
}

resource "aws_apigatewayv2_route" "any" {
  operation_name = "any"
  api_id         = aws_apigatewayv2_api.apiLambda_private.id
  route_key      = "ANY /{proxy+}"
  target         = "integrations/${aws_apigatewayv2_integration.apiLambda_private.id}"

#  authorization_type = "JWT"
#  authorizer_id = resource.aws_apigatewayv2_authorizer.jwt
#  authorization_scopes = "openid"
}

resource "aws_apigatewayv2_stage" "stage_name" {
  api_id      = aws_apigatewayv2_api.apiLambda_private.id
  name        = var.environment
  description = "state name for ${var.apigateway_name}-${var.environment}-${var.deploymentID}"
  auto_deploy = true
  default_route_settings {
    throttling_burst_limit = 50
    throttling_rate_limit  = 100
  }
}

resource "aws_lambda_permission" "allow_api" {
  statement_id_prefix = "ExecuteByAPI"
  action              = "lambda:InvokeFunction"
  function_name       = var.target_lambda_invoke_name
  principal           = "apigateway.amazonaws.com"
  source_arn          = aws_apigatewayv2_api.apiLambda_private.arn
}

resource "aws_cloudwatch_log_group" "apiLambda" {
  name              = "API-Gateway-Execution-Logs_${aws_apigatewayv2_api.apiLambda_private.id}/${var.environment}"
  retention_in_days = 7
  tags = var.tags
}

resource "aws_apigatewayv2_domain_name" "custom_name" {
  domain_name              = var.api_domain_name
  domain_name_configuration {
    certificate_arn = var.acm_arn
    endpoint_type            = "REGIONAL"
    security_policy          = "TLS_1_2"
  }
}

resource "aws_apigatewayv2_api_mapping" "custom_path" {
  api_id      = aws_apigatewayv2_api.apiLambda_private.id
  stage  = aws_apigatewayv2_stage.stage_name.id
  domain_name = aws_apigatewayv2_domain_name.custom_name.domain_name
}

#resource "aws_apigatewayv2_authorizer" "jwt" {
#  api_id           = aws_apigatewayv2_api.apiLambda_private.id
#  authorizer_type  = "JWT"
#  identity_sources = ["$request.header.Authorization"]
#  name             = "jwt authorizer"
#
#  jwt_configuration {
#    audience = ["openid","proxy"]
#    # token endpoint for auth0 or cognito
#    issuer   = "https://${aws_cognito_user_pool.example.endpoint}"
#  }
#}