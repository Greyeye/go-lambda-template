resource "aws_lambda_function" "lambda-function" {
  s3_bucket = var.lambda_dist_bucket
  s3_key = var.lambda_dist_key
  function_name = "${var.lambda_function_name}-${var.environment}-${var.deploymentID}"
  handler = var.lambda_function_handler
  role = var.lambda_role_arn
  runtime = var.lambda_runtime
  layers = var.lambda_layer
  vpc_config {
    security_group_ids = var.lambda_vpc_security_groups
    subnet_ids = var.lambda_vpc_subnet_ids
  }
  publish = false
  environment {
    variables = var.env_variables
  }
  source_code_hash = var.lambda_file_hash
  timeout = var.lambda_timeout
}

resource "aws_cloudwatch_log_group" "apiLambda" {
  name              = "/aws/lambda/${var.lambda_function_name}-${var.environment}-${var.deploymentID}"
  retention_in_days = 7
}

# runtimes
# https://docs.aws.amazon.com/lambda/latest/dg/lambda-runtimes.html

