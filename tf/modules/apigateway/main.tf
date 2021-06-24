resource "aws_api_gateway_rest_api" "apiLambda_private" {
  name        = "${var.apigateway_name}-${var.environment}-${var.deploymentID}"
  tags = var.tags
  endpoint_configuration {
    types = ["REGIONAL"]
  }
  policy = var.apigateway_policy
}

resource "aws_api_gateway_resource" "proxy" {
  rest_api_id = aws_api_gateway_rest_api.apiLambda_private.id
  parent_id   = aws_api_gateway_rest_api.apiLambda_private.root_resource_id
  path_part   = "{proxy+}"
}

resource "aws_api_gateway_method" "proxyMethod" {
  rest_api_id   = aws_api_gateway_rest_api.apiLambda_private.id
  resource_id   = aws_api_gateway_resource.proxy.id
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "lambda" {
  rest_api_id = aws_api_gateway_rest_api.apiLambda_private.id
  resource_id = aws_api_gateway_method.proxyMethod.resource_id
  http_method = aws_api_gateway_method.proxyMethod.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri = var.target_lambda_invoke_arn
}


resource "aws_api_gateway_deployment" "apideploy" {
  depends_on = [
    aws_api_gateway_integration.lambda
  ]
  rest_api_id = aws_api_gateway_rest_api.apiLambda_private.id

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "apiStage" {
  depends_on = [
    aws_api_gateway_deployment.apideploy,
    aws_cloudwatch_log_group.apiLambda
  ]

  rest_api_id = aws_api_gateway_rest_api.apiLambda_private.id
  stage_name  = var.environment
  deployment_id = aws_api_gateway_deployment.apideploy.id
  tags = var.tags

}

resource "aws_api_gateway_method_settings" "general_settings" {
  depends_on = [
    aws_api_gateway_stage.apiStage
  ]
  rest_api_id = aws_api_gateway_rest_api.apiLambda_private.id
  stage_name  = var.environment
  method_path = "*/*"

  settings {
    # Enable CloudWatch logging and metrics
    metrics_enabled        = false
    data_trace_enabled     = false
    logging_level          = "INFO"

    # Limit the rate of calls to prevent abuse and unwanted charges
    throttling_rate_limit  = 100
    throttling_burst_limit = 50
  }
}

resource "aws_cloudwatch_log_group" "apiLambda" {
  name              = "API-Gateway-Execution-Logs_${aws_api_gateway_rest_api.apiLambda_private.id}/${var.environment}"
  retention_in_days = 7
  tags = var.tags
}


resource "aws_api_gateway_domain_name" "custom_name" {
  domain_name              = var.api_domain_name
  regional_certificate_arn = var.acm_arn
  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_base_path_mapping" "custom_path" {
  api_id      = aws_api_gateway_rest_api.apiLambda_private.id
  stage_name  = aws_api_gateway_stage.apiStage.stage_name
  domain_name = aws_api_gateway_domain_name.custom_name.domain_name
}