output "completion_report_bucket" {
  description = "The name of the S3 bucket where cost and usage completion reports are stored."
  value       = aws_s3_bucket.completion_report
}

output "data_export_bucket" {
  description = "The name of the S3 bucket where cost and usage data exports are stored."
  value       = aws_s3_bucket.export
}

output "replication_role_arn" {
  description = "The ARN of the IAM role that can be assumed to perform replication of CUR data export reports."
  value       = aws_iam_role.replication_role.arn
}
