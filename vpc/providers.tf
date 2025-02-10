terraform {
  #############################################################
  ## AFTER RUNNING TERRAFORM APPLY (WITH LOCAL BACKEND)
  ## YOU WILL UNCOMMENT THIS CODE THEN RERUN TERRAFORM INIT
  ## TO SWITCH FROM LOCAL BACKEND TO REMOTE AWS BACKEND
  #############################################################
  backend "s3" {
    bucket = "okaratech-s3-tf-state-remote-backend" # REPLACE WITH YOUR BUCKET NAME
    key = "03-vpc/terraform.tfstate" # REPLACE ONLY THE FIRST TIME
    region  = "us-east-1" # REPLACE ONLY THE FIRST TIME
    dynamodb_table =  "okaratech-ddb-tf-state-lock-remote-backend" # REPLACE WITH YOUR DYNAMODB TABLE
    encrypt = true
    profile = "okaratech" # REPLACE WITH YOUR AWS PROFILE
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.42"
    }
  }
}


provider "aws" {
  region  = "us-east-1" # REPLACE ONLY THE FIRST TIME
  profile = "okaratech" # REPLACE ONLY THE FIRST TIME


  default_tags {
    tags = {
      "Owner"       = "BigCheese"
    }
  }
}