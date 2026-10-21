terraform {
  # Configuring official AWS terraform config
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

# Configuring real AWS dummy appointing to floci
provider "aws" {
  region     = var.region
  access_key = var.access_key
  secret_key = var.secret_key

  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true
  s3_use_path_style           = true

  endpoints {
    dynamodb       = var.endpoint
    secretsmanager = var.endpoint
    s3             = var.endpoint
    sns            = var.endpoint
    sqs            = var.endpoint
    ssm            = var.endpoint
    lambda         = var.endpoint
    iam            = var.endpoint
  }
}