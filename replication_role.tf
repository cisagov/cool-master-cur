# ------------------------------------------------------------------------------
# Create the IAM role that can be assumed to perform replication of CUR data
# export reports from our data export bucket to the destination bucket.
# ------------------------------------------------------------------------------

resource "aws_iam_role" "replication_role" {
  provider = aws.master

  assume_role_policy = data.aws_iam_policy_document.assume_role_doc.json
  description        = var.replication_role_description
  name               = var.replication_role_name
}

resource "aws_iam_role_policy_attachment" "replication_policy_attachment" {
  provider = aws.master

  policy_arn = aws_iam_policy.replication_policy.arn
  role       = aws_iam_role.replication_role.name
}
