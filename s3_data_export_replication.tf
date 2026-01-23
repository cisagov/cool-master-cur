# ------------------------------------------------------------------------------
# Set up replication configuration to replicate objects from the CUR data export
# bucket to the destination bucket.
# ------------------------------------------------------------------------------

resource "aws_s3_bucket_replication_configuration" "export" {
  provider = aws.master

  bucket = aws_s3_bucket.export.id
  role   = aws_iam_role.replication_role.arn

  depends_on = [
    aws_iam_role_policy_attachment.replication_policy_attachment,
    aws_s3_bucket_versioning.export,
  ]

  rule {
    id     = var.replication_rule_id
    status = "Enabled"

    # Replicate markers created by S3 delete operations
    delete_marker_replication {
      status = "Enabled"
    }

    destination {
      account = var.destination_bucket_account_id
      bucket  = "arn:aws:s3:::${var.destination_bucket_name}"

      # Change object ownership to the destination bucket owner
      access_control_translation {
        owner = "Destination"
      }

      # Enable replication metrics
      metrics {
        status = "Enabled"
      }
    }

    # Replicate all objects
    filter {
    }
  }
}
