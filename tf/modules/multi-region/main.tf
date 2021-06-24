resource "random_id" "server" {
  keepers = {
    region_name = var.aws_region
  }
  byte_length = 8
}

resource "aws_security_group" "allow_tls" {
  name        = "${var.lambda_sg_name}-${var.aws_region}-${var.environment}-${random_id.server.hex}"
  description = "Allow TLS inbound traffic"
  vpc_id      = var.vpc_id
  ingress {
    description      = "TLS from VPC"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = [var.vpc_cidr]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_tls ${var.lambda_sg_name}"
  }
}
locals {
  # don't include environment name, as tfvar should specify the environment name (eg mbp-development)
  bucket_name = "${var.lambda_dist_bucket}-${var.aws_region}-${var.environment}-${random_id.server.hex}"
}

resource "aws_s3_bucket" "lambda_dist" {
  bucket = local.bucket_name


  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
  policy = data.aws_iam_policy_document.bucket-policy.json
  tags = {
    Name = local.bucket_name
    Terraform = true
    Description = "terraform remote state storage for development do not delete"
  }
}

# prevent public access
resource "aws_s3_bucket_public_access_block" "dev" {
  bucket = aws_s3_bucket.lambda_dist.id
  block_public_acls   = true
  block_public_policy = true
  ignore_public_acls = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_object" "lambda_zip" {
  depends_on = [aws_s3_bucket.lambda_dist, module.dist_file]
  bucket = local.bucket_name
  key    = var.lambda_dist_key
  source = module.dist_file.filename

  # The filemd5() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the md5() function and the file() function:
  # etag = "${md5(file("path/to/file"))}"
  etag = module.dist_file.hash
}

terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 3.42.0"
    }
  }
  required_version = ">= 0.14.8"
}
