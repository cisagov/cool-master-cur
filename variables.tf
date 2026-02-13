# ------------------------------------------------------------------------------
# REQUIRED PARAMETERS
#
# You must provide a value for each of these parameters.
# ------------------------------------------------------------------------------

variable "data_export_bucket_name" {
  description = "The name of the S3 bucket where cost and usage data exports will be stored."
  nullable    = false
  type        = string
}

variable "data_export_completion_report_bucket_name" {
  description = "The name of the S3 bucket where cost and usage data export completion reports will be stored."
  nullable    = false
  type        = string
}

variable "destination_bucket_account_id" {
  description = "The AWS account ID that owns the S3 bucket to which cost and usage reports will be replicated."
  nullable    = false
  type        = string

  # Verify that the account ID is exactly 12 digits.
  validation {
    condition     = can(regex("^[0-9]{12}$", var.destination_bucket_account_id))
    error_message = "The destination_bucket_account_id must be exactly 12 digits."
  }
}

variable "destination_bucket_name" {
  description = "The name of the S3 bucket to which cost and usage reports will be replicated."
  nullable    = false
  type        = string
}

variable "terraform_state_bucket" {
  description = "The name of the S3 bucket where Terraform state is stored."
  nullable    = false
  type        = string
}

# ------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
#
# These parameters have reasonable defaults.
# ------------------------------------------------------------------------------

variable "aws_region" {
  default     = "us-east-1"
  description = "The AWS region to deploy into (e.g. us-east-1)."
  nullable    = false
  type        = string
}

variable "replication_policy_name" {
  default     = "cur-report-replication-policy"
  description = "The name of the IAM policy for S3 replication."
  nullable    = false
  type        = string
}

variable "replication_policy_description" {
  default     = "IAM policy to enable replication of Cost and Usage Report data exports to the destination bucket."
  description = "The description of the IAM policy for S3 replication."
  nullable    = false
  type        = string
}

variable "replication_role_name" {
  default     = "cur-report-replication-role"
  description = "The name of the IAM role for S3 replication."
  nullable    = false
  type        = string
}

variable "replication_role_description" {
  default     = "IAM role that can perform replication of Cost and Usage Report data exports to the destination bucket."
  description = "The description of the IAM role for S3 replication."
  nullable    = false
  type        = string
}

variable "replication_rule_id" {
  default     = "cur-replication"
  description = "The ID to assign to the S3 replication rule for Cost and Usage Report data exports."
  nullable    = false
  type        = string
}

variable "tags" {
  default     = {}
  description = "Tags to apply to all AWS resources created."
  nullable    = false
  type        = map(string)
}
