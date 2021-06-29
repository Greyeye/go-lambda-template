aws_region  = "us-east-1"

# environment name MUST match with branch name.
environment = "development"
accountnumber = "123456"

vpc_id = {
  "us-east-1" = "vpc-12345",
  "us-west-2" = "vpc-23456"
}

lambda_vpc_subnet_ids = {
  "us-east-1" = [
    "subnet-12345",
    "subnet-12346"],
  "us-west-2" = [
    "subnet-12347",
    "subnet-12348"]
}
vpc_cidr = {
  "us-east-1" = "10.0.0.0/16",
  "us-west-2" = "10.1.0.0/16"
}
lambda_dist_bucket = "go-lambda-template"
lambda_dist_key = "go-lambda-template/dist/lambda.zip"

// ACM certificate for acf.service.makeabeeline.dev and *.acf.service.makeabeeline.dev
// ACM requests take a time to validate(can take hrs), do not request ACM using terraform
acm_arns = {
  "us-east-1" = "arn:aws:acm:us-east-1:123456:certificate/123456",
  "us-west-2" = "arn:aws:acm:us-west-2:123456:certificate/123457"
}

project_name = "glt"

api_domain_name = "api.somedomainame.dev"
route53_zone_id = "Z0123456"

# runtimes
# https://docs.aws.amazon.com/lambda/latest/dg/lambda-runtimes.html
lambda_runtime = "go1.x"
lambda_timeout = 29