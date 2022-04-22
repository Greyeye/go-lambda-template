# go-lambda-template

Go lambda template using Gorilla Mux router.  

includes basic unit test sample.  

## How To use
1. create new repo using this as a template
2. copy all files ./tf/template to ./tf/development (rename *.tmpl to *.tf)
3. fill in details for backend and development and change the file name to backend.tf, development.tfvars, provider.tf
   Read ./tf/template/README.md for more information on templates.
4. Check AWS cred (or use aws sso to login to your sso profile)
5. Goto ./tf and run `terraform init` followed by `terraform plan -no-color -var-file development.tfvars -out=out.tfplan`
6. Deploy can be started by `terraform apply "out.tfplan"`

## NOTES 
1. Github Actions can perform Terraform Deployment,
   make sure you setup IAM roles and trust github actions from AWS. 
   See (https://docs.github.com/en/actions/deployment/security-hardening-your-deployments/configuring-openid-connect-in-amazon-web-services)
2. IAM role trust relationship must refer to OIDC token providers and right Conditions, please see ./docs/sampleIAMRoleTrustedPolicy.json
3. Do not **FORK**, use it as template or just clone and detach. If you fork, you will not be able to set the repo as private.

