# ------------------------------------------------------------------------------
# Provision an S3 bucket to store CUR data exports.
# ------------------------------------------------------------------------------

resource "aws_s3_bucket" "export" {
  provider = aws.master

  bucket = var.data_export_bucket_name
  tags = {
    "Name" = "CUR data exports bucket"
  }
}

# Ensure the S3 bucket is encrypted
resource "aws_s3_bucket_server_side_encryption_configuration" "export" {
  provider = aws.master

  bucket = aws_s3_bucket.export.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# This blocks ANY public access to the bucket or the objects it
# contains, even if misconfigured to allow public access.
resource "aws_s3_bucket_public_access_block" "export" {
  provider = aws.master

  block_public_acls       = true
  block_public_policy     = true
  bucket                  = aws_s3_bucket.export.id
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Any objects placed into this bucket should be owned by the bucket
# owner. This ensures that even if objects are added by a different
# account, the bucket-owning account retains full control over the
# objects stored in this bucket.
resource "aws_s3_bucket_ownership_controls" "export" {
  provider = aws.master

  bucket = aws_s3_bucket.export.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

# Enable versioning on the bucket.
resource "aws_s3_bucket_versioning" "export" {
  provider = aws.master

  bucket = aws_s3_bucket.export.id

  versioning_configuration {
    status = "Enabled"
  }
}

# Define bucket access policy to allow the CUR service to write to this bucket
# and support replication to the destination bucket.
data "aws_iam_policy_document" "export_bucket_policy_doc" {
  provider = aws.master

  statement {
    actions = [
      "s3:GetBucketPolicy",
      "s3:ListBucket",
      "s3:PutInventoryConfiguration",
      "s3:PutObject",
    ]

    condition {
      test     = "StringLike"
      values   = [local.master_account_id]
      variable = "aws:SourceAccount"
    }

    condition {
      test = "StringLike"
      values = [
        "arn:aws:cur:${var.aws_region}:${local.master_account_id}:definition/*",
        "arn:aws:bcm-data-exports:${var.aws_region}:${local.master_account_id}:export/*",
      ]
      variable = "aws:SourceArn"
    }

    principals {
      identifiers = [
        "bcm-data-exports.amazonaws.com",
        "billingreports.amazonaws.com",
      ]
      type = "Service"
    }

    resources = [
      aws_s3_bucket.export.arn,
      "${aws_s3_bucket.export.arn}/*",
    ]

    sid = "EnableAWSDataExportsToWriteToS3AndCheckPolicy"
  }
}

resource "aws_s3_bucket_policy" "export" {
  provider = aws.master

  bucket = aws_s3_bucket.export.id
  policy = data.aws_iam_policy_document.export_bucket_policy_doc.json
}
