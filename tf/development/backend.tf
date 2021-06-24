terraform {
  backend "s3" {
    bucket         = "Greyeye-terraform-backend-development"
    key            = "go-lambda-template/state/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-locks-development"
  }
}
