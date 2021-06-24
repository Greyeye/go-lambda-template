# Terraform template

## Project structure
1. Environment specific Terraform Code:
   Environment name should match the branch names, development and master.  
   Using the environment specific variable (eg development.tfvars) 
   terraform will run to create/modify/destroy accordingly.  
   \<branch name\>/main.tf will control deployment to different region and global service such as Route53.
2. environment.tfvars: 
   tfvars file control the environment specific or pre-created resources that are outside terraform control.
   Resources such as VPC/Subnets/SecurityGroups/ACMs/S3 buckets needs to be specified.  
   **Please read the environment.tfvar** and 
   make sure you have specified the correct resources before deploying to a new environment.
3. modules folders:
   Modules folder contains the service specific controls and multi-region ready module. 
   \<environment\>/main.tf will invoke modules/multi-region/main.tf to start deployment.  
   
4. Route53 deployment:
   Route53 cannot be deployed inside multi-region module.   
   Bug with AWS provider of 0.36 (May/2021)  
   Adding A RECORD with healthcheck using us-east-1 specific module AND us-west-2 service
   on a single run will fail during record creation.  
   Provider was trying to create A RECORD using us-east-1's health check even though us-west-2's health is specified.  
   Creating a completely separate module did not work either.  
   **Workaround is to create a us-west-2 record manually.**
   
## Required Parameters (environment.tfvars)

* aws_region: name of the region (eg us-east-1, us-west-2)
* environment: name of the target environment, this must match the branch names. (eg development, main, master)
* accountnumber: AWS Account number to deploy to
* vpc_id: **map** of VPC ID for each region.
* lambda_vpc_security_groups: **map** of VPC Security Groups for lambda
* lambda_vpc_subnet_ids: **map** of VPC Subnet IDs for lambda.
* vpc_cidr: **map** of VPC Network CIDR
* lambda_dist_bucket: S3 Bucket Name for labmda source code deploy.
* lambda_dist_key: S3 Key Name (Filename) for the source code deploy.
* acm_arns: **map** of ACM certificate to be used with API Gateway Custom domains. Dont use Terraform to deploy ACM, as validation can take more than an hr.
* api_domain_name: Custom DNS name to be used by API Gateway (must match ACM)
* route53_zone_id: Route53 Zone ID to be used to update Custom Domain Name of API Gateway
* project_name: used to define project specific names,  
  please dont make it too long, as some system cannot take more than 64 characters. This template will add
  environment and random code to postfix of most names.
  (*not good* -> my-super-great-project)
  (*good* -> "msgp")
  (*end result* -> msgp-development-671711b016dce878)
* lambda_runtime: specify what runtime lambda will run (eg node14.x)

