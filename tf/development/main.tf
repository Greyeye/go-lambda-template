module "us-east-1" {
  source = "../modules/multi-region"
  aws_region = "us-east-1"
  environment = var.environment
  accountnumber = var.accountnumber
  lambda_vpc_subnet_ids = var.lambda_vpc_subnet_ids["us-east-1"]
  lambda_dist_bucket = var.lambda_dist_bucket
  lambda_dist_key = var.lambda_dist_key
  lambda_sg_name = "${var.project_name}-sg"
  lambda_name = var.project_name
  vpc_id = var.vpc_id["us-east-1"]
  vpc_cidr = var.vpc_cidr["us-east-1"]
  acm_arn = var.acm_arns["us-east-1"]
  api_domain_name =  var.api_domain_name
  route53_zone_id = var.route53_zone_id
  lambda_policy = data.aws_iam_policy_document.lambda_policy.json
  lambda_runtime = var.lambda_runtime
  env_variables = local.env_variables
  lambda_timeout = var.lambda_timeout
}

module "us-west-2" {
  source = "../modules/multi-region"
  providers = {
    aws = aws.us-west-2
  }
  aws_region = "us-west-2"
  environment = var.environment
  accountnumber = var.accountnumber
  lambda_vpc_subnet_ids = var.lambda_vpc_subnet_ids["us-west-2"]
  lambda_dist_bucket = var.lambda_dist_bucket
  lambda_dist_key = var.lambda_dist_key
  lambda_sg_name = "${var.project_name}-sg"
  lambda_name = var.project_name
  vpc_id = var.vpc_id["us-west-2"]
  vpc_cidr = var.vpc_cidr["us-west-2"]
  acm_arn = var.acm_arns["us-west-2"]
  api_domain_name =  var.api_domain_name
  route53_zone_id = var.route53_zone_id
  lambda_policy = data.aws_iam_policy_document.lambda_policy.json
  lambda_runtime = var.lambda_runtime
  env_variables = local.env_variables
  lambda_timeout = var.lambda_timeout
}

module "r53_healthcheck_useast1" {
  depends_on = [module.us-east-1]
  source = "../modules/r53-healthcheck"
  apigw_host_name = module.us-east-1.apigw_host_name
  environment = var.environment
  deploymentID = module.us-east-1.random_hex
}

module "r53usest1" {
  depends_on = [module.us-east-1]
  source = "../modules/route53"
  route53_zone_id = var.route53_zone_id
  regional_host_name =  module.us-east-1.regional_host_name
  apigw_zone_id = module.us-east-1.apigw_zone_id
  apigw_host_name = module.us-east-1.apigw_host_name
  environment = var.environment
  deploymentID = module.us-east-1.random_hex
  healthcheckid = module.r53_healthcheck_useast1.healthcheckid
  healthcheckpriority = "PRIMARY"
}
