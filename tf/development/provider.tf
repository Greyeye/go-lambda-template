# _provider.tf
provider "aws" {
  region = "us-east-1"
  profile = "beeline-development"
}

provider "aws" {
  alias  = "us-west-2"
  region = "us-west-2"
  profile = "beeline-development"
}
