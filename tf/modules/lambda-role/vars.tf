variable lambda_name {}

variable policy {
  description = "lambda policy, you can substitute your own aws_iam_policy_document, or use default basic Lambda VPC exec Policy defined in the module"
  default = null
}

variable environment {
  description = "deployment target, use developemnt or main"
  default = "development"
}
variable aws_region {
  default = "us-east-1"
}
variable accountnumber {
}

variable tags {
  default = null
}

variable "deploymentID" {

}