output "s3_bucket_name" {
  description = "Bucket name where the tfstate files are stored"
  value       = aws_s3_bucket.terraform_state.id
}

output "dynamodb_table_name" {
  description = "DynamoDB table used for locking files"
  value       = aws_dynamodb_table.terraform_locks.id
}