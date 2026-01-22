# cool-master-cur #

[![GitHub Build Status](https://github.com/cisagov/cool-master-cur/workflows/build/badge.svg)](https://github.com/cisagov/cool-master-cur/actions)
[![License](https://img.shields.io/github/license/cisagov/cool-master-cur)](https://spdx.org/licenses/)
[![CodeQL](https://github.com/cisagov/cool-master-cur/workflows/CodeQL/badge.svg)](https://github.com/cisagov/cool-master-cur/actions/workflows/codeql-analysis.yml)

This is a Terraform module for creating resources in a COOL Master account in
order to replicate AWS Cost and Usage Reports (CUR) to a designated S3 bucket.

## Pre-requisites ##

- [Terraform](https://www.terraform.io/) installed on your system.
- An accessible AWS S3 bucket to store Terraform state
  (specified in [backend.tf](backend.tf)).
- An accessible AWS DynamoDB database to store the Terraform state lock
  (specified in [backend.tf](backend.tf)).
- Access to all of the Terraform remote states specified in
  [remote_states.tf](remote_states.tf).

## Usage ##

For the purposes of these instructions, assume the environment is named "dev";
replace "dev" in the instructions below with your environment name if needed.

1. Create a backend configuration file named `dev.tfconfig` containing the name
   of the bucket where Terraform state is stored for that environment.

    ```hcl
    bucket = "my-dev-terraform-state-bucket"
    ```

1. Initialize the Terraform backend for the "dev" environment using your backend
   configuration file:

    ```console
    terraform init -upgrade -backend-config=dev.tfconfig
    ```

    > [!NOTE] When performing this step for additional environments (i.e. not
    > your first environment), use the `-reconfigure` flag:
    >
    > ```console
    > terraform init -upgrade -backend-config=other-env.tfconfig -reconfigure
    > ```

1. Create a Terraform workspace (if you haven't already done so) by running
   `terraform workspace new dev`
1. Create a `dev.tfvars` file with all required variables and any optional
   variables that you wish to override (see [Inputs](#inputs) below for
   details):

   ```console
   data_export_bucket_name                   = "my-cur-export-bucket"
   data_export_completion_report_bucket_name = "my-cur-export-completion-report-bucket"
   destination_bucket_account_id             = "123456789012"
   destination_bucket_name                   = "destination-cur-bucket"

   tags = {
     Team        = "Your Team Name"
     Application = "COOL - Master CUR"
     Workspace   = "dev"
   }

   terraform_state_bucket = "my-terraform-state-bucket"
   ```

1. Run the command `terraform apply -var-file=dev.tfvars`.

<!-- BEGIN_TF_DOCS -->
## Requirements ##

| Name | Version |
|------|---------|
| terraform | >= 1.1 |
| aws | >= 4.9 |

## Providers ##

| Name | Version |
|------|---------|
| aws | >= 4.9 |
| aws.master | >= 4.9 |
| terraform | n/a |

## Modules ##

No modules.

## Resources ##

| Name | Type |
|------|------|
| [aws_iam_policy.replication_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.replication_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.replication_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_s3_bucket.completion_report](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket.export](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_ownership_controls.completion_report](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_ownership_controls) | resource |
| [aws_s3_bucket_ownership_controls.export](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_ownership_controls) | resource |
| [aws_s3_bucket_policy.export](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |
| [aws_s3_bucket_public_access_block.completion_report](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_s3_bucket_public_access_block.export](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_s3_bucket_replication_configuration.export](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_replication_configuration) | resource |
| [aws_s3_bucket_server_side_encryption_configuration.completion_report](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_server_side_encryption_configuration) | resource |
| [aws_s3_bucket_server_side_encryption_configuration.export](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_server_side_encryption_configuration) | resource |
| [aws_s3_bucket_versioning.export](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_versioning) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_caller_identity.master](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.assume_role_doc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.export_bucket_policy_doc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.replication_doc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [terraform_remote_state.master](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |

## Inputs ##

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| aws\_region | The AWS region to deploy into (e.g. us-east-1). | `string` | `"us-east-1"` | no |
| data\_export\_bucket\_name | The name of the S3 bucket where cost and usage data exports will be stored. | `string` | n/a | yes |
| data\_export\_completion\_report\_bucket\_name | The name of the S3 bucket where cost and usage data export completion reports will be stored. | `string` | n/a | yes |
| destination\_bucket\_account\_id | The AWS account ID that owns the S3 bucket to which cost and usage reports will be replicated. | `string` | n/a | yes |
| destination\_bucket\_name | The name of the S3 bucket to which cost and usage reports will be replicated. | `string` | n/a | yes |
| replication\_policy\_description | The description of the IAM policy for S3 replication. | `string` | `"IAM policy to enable replication of Cost and Usage Report data exports to the destination bucket."` | no |
| replication\_policy\_name | The name of the IAM policy for S3 replication. | `string` | `"cur-report-replication-policy"` | no |
| replication\_role\_description | The description of the IAM role for S3 replication. | `string` | `"IAM role that can perform replication of Cost and Usage Report data exports to the destination bucket."` | no |
| replication\_role\_name | The name of the IAM role for S3 replication. | `string` | `"cur-report-replication-role"` | no |
| replication\_rule\_id | The ID to assign to the S3 replication rule for Cost and Usage Report data exports. | `string` | `"cur-replication"` | no |
| tags | Tags to apply to all AWS resources created. | `map(string)` | `{}` | no |
| terraform\_state\_bucket | The name of the S3 bucket where Terraform state is stored. | `string` | n/a | yes |

## Outputs ##

| Name | Description |
|------|-------------|
| completion\_report\_bucket | The name of the S3 bucket where cost and usage completion reports are stored. |
| data\_export\_bucket | The name of the S3 bucket where cost and usage data exports are stored. |
| replication\_role\_arn | The ARN of the IAM role that can be assumed to perform replication of CUR data export reports. |
<!-- END_TF_DOCS -->

## Notes ##

Running `pre-commit` requires running `terraform init` in every directory that
contains Terraform code. In this repository, this is just the main directory.

## Contributing ##

We welcome contributions!  Please see [`CONTRIBUTING.md`](CONTRIBUTING.md) for
details.

## License ##

This project is in the worldwide [public domain](LICENSE).

This project is in the public domain within the United States, and
copyright and related rights in the work worldwide are waived through
the [CC0 1.0 Universal public domain
dedication](https://creativecommons.org/publicdomain/zero/1.0/).

All contributions to this project will be released under the CC0
dedication. By submitting a pull request, you are agreeing to comply
with this waiver of copyright interest.
