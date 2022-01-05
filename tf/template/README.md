# Terraform config template files 

Template files to be used to dynamically fill in the variables.

Please fill in the template and copy the filled files to /tf/development or tf/main

## Steps:  
1. replace `{{.varname}}` to "variable" 
2. save tmpl file as .tf file
3. save file under /tf/development 

## sample steps

```terraform
provider "aws" {
  region = "us-east-1"
  profile = {{.awsCredProviderName}}   # e.g. "development"
}

provider "aws" {
  alias  = "us-west-2"
  region = "us-west-2"
  profile = {{.awsCredProviderName}}   # e.g. "development"
}
```
replace `{{.awsCredProviderName}}` with aws credentials name (eg section name of ~/.aws/credentials), such as "production", "development".  
If you are using AWS SSO, please use AWS SSO profile name.  

variables replaced like one below.
```terraform
provider "aws" {
  region = "us-east-1"
  profile = "development"
}

provider "aws" {
  alias  = "us-west-2"
  region = "us-west-2"
  profile = "development"
}
```
