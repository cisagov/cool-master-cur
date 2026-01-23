# ------------------------------------------------------------------------------
# Create an IAM policy document that allows the Amazon S3 and S3 Batch
# Operations services to assume this role.
# ------------------------------------------------------------------------------

data "aws_iam_policy_document" "assume_role_doc" {
  statement {
    actions = [
      "sts:AssumeRole",
      "sts:TagSession",
    ]

    principals {
      identifiers = [
        "batchoperations.s3.amazonaws.com",
        "s3.amazonaws.com",
      ]
      type = "Service"
    }
  }
}
