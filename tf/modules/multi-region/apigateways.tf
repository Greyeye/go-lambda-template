module "api" {
  source = "../apigateway"
  depends_on = [
    module.lambda_function
  ]
  apigateway_name = "${var.lambda_name}_api"
  target_lambda_invoke_arn = module.lambda_function.lambda_invoke_arn
  //  deploy_environment = var.environment
  tags = {
    Name = "${var.lambda_name}_api-${var.environment}-${random_id.server.hex}"
    Terraform = true
    Description = "api endpoint for ${var.lambda_name}"
  }
//  target_lambda_name = module.sft_validate_lambda_function.lambda_function_name
  environment = var.environment
  apigateway_policy = data.aws_iam_policy_document.apigateway_resource_policy.json
  deploymentID = random_id.server.hex
  api_domain_name = var.api_domain_name
  acm_arn = var.acm_arn
}
