terraform {

  required_version = ">= 1.0.0"
  backend "s3" {
    bucket = "miluna-bucket-eks"
    key    = "myproyectoeks/terraform.tfstate"
    region = "sa-east-1"
    encrypt = true
    dynamodb_table = "miluna-dynamo-eks"
  }


  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.0"
    } 
  }

}

provider "aws" {
  region = var.region
}

