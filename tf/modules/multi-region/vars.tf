variable "aws_region" {
  description = "aws region"
}
variable "environment" {
  description = "type of environment, development, production"
}

variable "accountnumber" {
  description = "aws account number"
}

variable "lambda_vpc_subnet_ids" {}


variable "lambda_dist_bucket" {
}
variable "lambda_sg_name" {}
variable "lambda_name" {}
variable "lambda_dist_key" {}
variable "vpc_id" {
  default = "vpc-08789c303a76dcf84"
}
variable "vpc_cidr"{}

variable "acm_arn" {}
variable "api_domain_name" {}
variable "route53_zone_id" {}

variable "lambda_policy" {}
variable "env_variables" {}
variable "lambda_runtime" {}
variable "lambda_timeout" {}