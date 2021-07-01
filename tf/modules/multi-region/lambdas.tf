
module dist_file {
  source = "../lambda_archive"
  dist_dir = "../../src"
  zip_file_name = "../../dist/lambda.zip"
}

locals {
  lambda_name = var.lambda_name
}
module "lambda-role" {
  source = "../lambda-role"
  aws_region = var.aws_region
  lambda_name = local.lambda_name
  accountnumber = var.accountnumber
  tags = {
    Name = "${local.lambda_name}-role"
    Terraform = true
    DeploymentID = random_id.server.hex
  }
  policy = var.lambda_policy
  deploymentID = random_id.server.hex
  environment = var.environment
}

module "lambda_function" {
  depends_on = [aws_s3_bucket_object.lambda_zip]
  source = "../lambda"
  lambda_filename = module.dist_file.filename
  lambda_dist_bucket = aws_s3_bucket_object.lambda_zip.bucket
  lambda_dist_key = var.lambda_dist_key
  lambda_function_name = local.lambda_name
  lambda_function_handler = "main"
  lambda_role_arn = module.lambda-role.lambda_role_arn
  lambda_runtime = var.lambda_runtime
  lambda_vpc_security_groups = [aws_security_group.allow_tls.id]
  lambda_vpc_subnet_ids = var.lambda_vpc_subnet_ids
  env_variables = var.env_variables
  lambda_file_hash = module.dist_file.filebase64sha256
  deploymentID = random_id.server.hex
  environment = var.environment
  lambda_timeout = var.lambda_timeout
}

data "local_file" "env_variables" {
  filename = "../../config/env_${var.environment}.json"
}

resource "aws_lambda_permission" "lambda_permission" {
  depends_on = [
    module.api
  ]
  statement_id  = "AllowValidateAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = "${local.lambda_name}-${var.environment}-${random_id.server.hex}"
  principal     = "apigateway.amazonaws.com"

  # The /*/*/* part allows invocation from any stage, method and resource path
  # within API Gateway REST API.
  source_arn = "${module.api.apigateway_execution_arn}/*/*/*"
}
