output "lambda_arn" {
  value = aws_lambda_function.lambda-function.arn
}
output "lambda_id" {
  value = aws_lambda_function.lambda-function.id
}
output "lambda_invoke_arn" {
  value = aws_lambda_function.lambda-function.invoke_arn
}

output "lambda_function_name" {
  value = aws_lambda_function.lambda-function.function_name
}
