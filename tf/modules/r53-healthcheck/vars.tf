variable deploymentID {}
variable environment {}
variable apigw_host_name {}
variable "health_check_regions" {
  description = "AWS Regions for health check"
  type        = list(string)
  default     = ["us-east-1", "us-west-1", "us-west-2"]
}
