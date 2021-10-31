variable "aws_region" {
  description = "aws region"
}
variable "environment" {
  description = "type of environment, development, production"
}

variable "accountnumber" {
  description = "aws account number"
}

variable "lambda_vpc_subnet_ids" {
  description = "VPC subnets used by the lambda"
  type = object({
    us-east-1 = list(string)
    us-west-2 = list(string)
  })
}


variable "lambda_dist_bucket" {
  description = "S3 bucket where source code is uploaded"
}

variable "lambda_dist_key" {
  description = "lambda source code file name in S3 bucket"
}

variable "vpc_id" {
  description = "VPC ID for lambda to execute"
  type = object({
    us-east-1 = string
    us-west-2 = string
  })

}

variable "vpc_cidr" {
  description = "VPC network subnet CIDR"
  type = object({
    us-east-1 = string
    us-west-2 = string
  })
}

variable "acm_arns" {
  # Please create a ACM cert dedicated for the API
  # (eg *.<apiname>.service.makeabeeline.com and <apiname>.service.makeabeeline.com)
  description = "AMAZON Certificate Manager's cert arn to be used for custom domain"
  type = object({
    us-east-1 = string
    us-west-2 = string
  })
}

variable "api_domain_name" {
  description = "DNS name to use for the API gateway"
}

variable "route53_zone_id" {
  # please create a sub domain zone dedicated for the project
  description = "Route53 zone ID to make change"
}

variable project_name {
  description = "Project Name"
  type = string
}

variable "lambda_runtime" {
  description = "lambda run time, please use one from the url https://docs.aws.amazon.com/lambda/latest/dg/API_CreateFunction.html#SSS-CreateFunction-request-Runtime"
  type = string
}

variable "lambda_timeout" {
  description = "maximum time lambda is allowed to run. If its running behind an API Gateway, timeout should not excees 29secs"
}

variable "lambda_architecture" {
  description = "set lambda run time architectures. Use arm64, amd64"
}