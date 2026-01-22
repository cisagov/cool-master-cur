# ------------------------------------------------------------------------------
# Create the IAM policy that enables replication of CUR data export reports from
# our data export bucket to the destination bucket.
# ------------------------------------------------------------------------------

data "aws_iam_policy_document" "replication_doc" {
  statement {
    actions = [
      "s3:GetObjectLegalHold",
      "s3:GetObjectRetention",
      "s3:GetObjectVersionAcl",
      "s3:GetObjectVersionForReplication",
      "s3:GetObjectVersionTagging",
      "s3:GetReplicationConfiguration",
      "s3:InitiateReplication",
      "s3:ListBucket",
      "s3:PutInventoryConfiguration",
    ]

    resources = [
      aws_s3_bucket.export.arn,
      "${aws_s3_bucket.export.arn}/*",
    ]
  }

  statement {
    actions = [
      "s3:ObjectOwnerOverrideToBucketOwner",
      "s3:ReplicateDelete",
      "s3:ReplicateObject",
      "s3:ReplicateTags",
    ]

    resources = [
      "arn:aws:s3:::${var.destination_bucket_name}/*",
    ]
  }

  statement {
    actions = [
      "s3:PutObject",
    ]

    resources = [
      "${aws_s3_bucket.completion_report.arn}/*",
    ]
  }
}

# The IAM policy
resource "aws_iam_policy" "replication_policy" {
  provider = aws.master

  description = var.replication_policy_description
  name        = var.replication_policy_name
  policy      = data.aws_iam_policy_document.replication_doc.json
}
