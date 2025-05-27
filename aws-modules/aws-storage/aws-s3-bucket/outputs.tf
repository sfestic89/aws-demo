output "bucket_id" {
  description = "The name of the bucket"
  value       = aws_s3_bucket.s3_bucket.id
}

output "bucket_arn" {
  description = "The ARN of the bucket"
  value       = aws_s3_bucket.s3_bucket.arn
}

output "bucket_domain_name" {
  description = "The bucket domain name"
  value       = aws_s3_bucket.s3_bucket.bucket_domain_name
}

output "bucket_regional_domain_name" {
  description = "The regional domain name of the bucket"
  value       = aws_s3_bucket.s3_bucket.bucket_regional_domain_name
}

output "bucket_hosted_zone_id" {
  description = "The Route 53 Hosted Zone ID for the bucket"
  value       = aws_s3_bucket.s3_bucket.hosted_zone_id
}

output "bucket_logging" {
  description = "Logging configuration details if enabled"
  value = try(
    aws_s3_bucket_logging.s3_bucket_logging[0].target_bucket,
    null
  )
}

output "versioning_status" {
  description = "The versioning status of the bucket"
  value       = aws_s3_bucket_versioning.s3_bucket_versioning.versioning_configuration[0].status
}
