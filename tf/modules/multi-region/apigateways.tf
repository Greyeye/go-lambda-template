module "api" {
  source = "../apigatewayv2"
  depends_on = [
    module.lambda_function
  ]
  apigateway_name = "${var.lambda_name}_api"
  target_lambda_invoke_arn = module.lambda_function.lambda_invoke_arn
  tags = {
    Name = "${var.lambda_name}_api-${var.environment}-${random_id.server.hex}"
    Terraform = true
    Description = "api endpoint for ${var.lambda_name}"
  }
  environment = var.environment
  deploymentID = random_id.server.hex
  api_domain_name = var.api_domain_name
  acm_arn = var.acm_arn
  aws_account_id = var.accountnumber
  target_lambda_invoke_name = module.lambda_function.lambda_function_name
}
module "api" {
  source = "../apigateway"
  depends_on = [
    module.lambda_function
  ]
  apigateway_name = "${var.lambda_name}_api"
  target_lambda_invoke_arn = module.lambda_function.lambda_invoke_arn
  tags = {
    Name = "${var.lambda_name}_api-${var.environment}-${random_id.server.hex}"
    Terraform = true
    Description = "api endpoint for ${var.lambda_name}"
  }
  environment = var.environment
  deploymentID = random_id.server.hex
  api_domain_name = var.api_domain_name
  acm_arn = var.acm_arn
  aws_account_id = var.accountnumber
}