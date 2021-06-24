variable "apigateway_name" {

}

//variable "target_lambda_name" {
//
//}
variable "target_lambda_invoke_arn" {

}

//variable "deploy_environment" {}

variable "tags" {
  default = null
}

variable "aws_region" {
  default = "us-east-1"
}

variable "aws_account_id" {
  default = "296340400447"
}

variable "environment" {
  default = "scaffolding_alias"
}
variable "apigateway_policy" {}

variable "deploymentID" {

}

variable "api_domain_name" {}
variable "acm_arn" {}