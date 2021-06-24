variable "lambda_function_name" {}
variable "lambda_role_arn" {}
variable "lambda_zip_filename" {
  default = null
}
variable "lambda_function_handler" {
  default = "main"
}
variable "lambda_runtime" {
  default = "nodejs14.x"
}
variable "lambda_layer" {
  default = null
}

variable "lambda_vpc_security_groups" {
  default = null
}
variable "lambda_vpc_subnet_ids" {
  default = null
}

variable "lambda_filename" {}
variable "lambda_file_hash" {}

variable lambda_dist_bucket {}
variable lambda_dist_key {}

variable "env_variables" {
  default = null
}

variable "deploymentID" {

}

variable "environment" {}
variable "lambda_timeout" {}