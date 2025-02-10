locals {
  s3_bucket_name = format("%s-s3-tf-state-%s", var.prefix_resource_name, var.app_name)
  dynamodb_name  = format("%s-ddb-tf-state-lock-%s", var.prefix_resource_name, var.app_name)
}

##################################################################
# S3 Bucket
##################################################################
resource "aws_s3_bucket" "terraform_state" {
  bucket        = local.s3_bucket_name
  force_destroy = true
  
}

resource "aws_s3_bucket_versioning" "terraform_bucket_versioning" {
  bucket = aws_s3_bucket.terraform_state.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state_crypto_conf" {
  bucket = aws_s3_bucket.terraform_state.bucket
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

##################################################################
# DynamoDB
##################################################################

resource "aws_dynamodb_table" "terraform_locks" {
  name         = local.dynamodb_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}