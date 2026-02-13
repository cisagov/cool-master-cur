# ------------------------------------------------------------------------------
# Provision an S3 bucket to store CUR completion reports.
# ------------------------------------------------------------------------------

resource "aws_s3_bucket" "completion_report" {
  provider = aws.master

  bucket = var.data_export_completion_report_bucket_name
  tags = {
    "Name" = "CUR completion reports bucket"
  }
}

# Ensure the S3 bucket is encrypted
resource "aws_s3_bucket_server_side_encryption_configuration" "completion_report" {
  provider = aws.master

  bucket = aws_s3_bucket.completion_report.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# This blocks ANY public access to the bucket or the objects it
# contains, even if misconfigured to allow public access.
resource "aws_s3_bucket_public_access_block" "completion_report" {
  provider = aws.master

  block_public_acls       = true
  block_public_policy     = true
  bucket                  = aws_s3_bucket.completion_report.id
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Any objects placed into this bucket should be owned by the bucket
# owner. This ensures that even if objects are added by a different
# account, the bucket-owning account retains full control over the
# objects stored in this bucket.
resource "aws_s3_bucket_ownership_controls" "completion_report" {
  provider = aws.master

  bucket = aws_s3_bucket.completion_report.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

# Note that versioning is not required for this bucket.
