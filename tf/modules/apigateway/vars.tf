variable "apigateway_name" {

}
variable "target_lambda_invoke_arn" {

}

variable "tags" {
  default = null
}

variable "aws_region" {
  default = "us-east-1"
}

variable "aws_account_id" {}

variable "environment" {
  default = "scaffolding_alias"
}
variable "apigateway_policy" {}

variable "deploymentID" {

}

variable "api_domain_name" {}
variable "acm_arn" {}