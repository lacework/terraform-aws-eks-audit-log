<a href="https://lacework.com"><img src="https://techally-content.s3-us-west-1.amazonaws.com/public-content/lacework_logo_full.png" width="600"></a>

# terraform-aws-eks-audit-log

[![GitHub release](https://img.shields.io/github/release/lacework/terraform-aws-eks-audit-log.svg)](https://github.com/lacework/terraform-aws-eks-audit-log/releases/)
[![Codefresh build status]( https://g.codefresh.io/api/badges/pipeline/lacework/terraform-modules%2Ftest-compatibility?type=cf-1&key=eyJhbGciOiJIUzI1NiJ9.NWVmNTAxOGU4Y2FjOGQzYTkxYjg3ZDEx.RJ3DEzWmBXrJX7m38iExJ_ntGv4_Ip8VTa-an8gBwBo)]( https://g.codefresh.io/pipelines/edit/new/builds?id=607e25e6728f5a6fba30431b&pipeline=test-compatibility&projects=terraform-modules&projectId=607db54b728f5a5f8930405d)

A Terraform Module to integrate Amazon Elastic Kubernetes Service (EKS) with Lacework.

## Resources created
- SNS topic
- Topic policy
- S3 bucket
- S3 bucket notification
- Firehose
- Firehose IAM role & policy
- Cross account IAM role & policy
- Cloudwatch IAM role & policy
- Cloudwatch subscription filter

## Inputs

| Name                        | Description                                                                                                          | Type           | Default                     | Required |
| --------------------------- | -------------------------------------------------------------------------------------------------------------------- | -------------  | --------------------------- | :------: |
| bucket_enable_encryption    | Set this to `true` to enable encryption on a created S3 bucket                                                       | `bool`         | `false`                     |    no    |
| bucket_enable_mfa_delete    | Set this to `true` to require MFA for object deletion (Requires versioning)                                          | `bool`         | `false`                     |    no    |
| bucket_enable_versioning    | Set this to `true` to enable access versioning on a created S3 bucket                                                | `bool`         | `false`                     |    no    |
| bucket_force_destroy        | Force destroy bucket (Required when bucket not empty)                                                                | `bool`         | `false`                     |    no    |
| cloudwatch_region           | The region, to stream CloudWatch logs from                                                                           | `string`       |                             |    yes   |
| cluster_names               | A list of cluster names, within the cloudwatch region to integrate with                                              | `list(string)` |                             |    yes   |
| external_id_length          | The length of the external ID to generate. Max length is 1224.                                                       | `number`       | `16`                        |    no    |
| integration_name            | The name of the AWS EKS Audit Log integration in Lacework                                                            | `string`       | `TF AWS EKS Audit Log`      |    no    |
| lacework_aws_account_id     | The Lacework AWS account that the IAM role will grant access                                                         | `string`       | `"434813966438"`            |    no    |
| prefix                      | The prefix that will be use at the beginning of every generated resource                                             | `string`       | `"lacework-s3-data-export"` |    no    |
| tags                        | A map/dictionary of Tags to be assigned to created resources                                                         | `map(string)`  | `{}`                        |    no    |
| wait_time                   | Amount of time to wait before the next resource is provisioned.                                                      | `string`       | `"10s"`                     |    no    |

## Outputs

| Name                        | Description                                                |
| --------------------------- | ---------------------------------------------------------- |
| bucket_arn                  | S3 Bucket ARN                                              |
| bucket_name                 | S3 Bucket name                                             |
| cloudwatch_iam_role_name    | The Cloudwatch IAM Role name                               |
| cross_account_iam_role_name | The Cross Account IAM Role name                            |
| external_id                 | The External ID configured into the Cross Account IAM role |
| firehose_arn                | Firehose Delivery Stream ARN                               |
| firehose_iam_role_name      | The Firehose IAM Role name                                 |
| iam_role_arn                | The IAM Role ARN                                           |
| iam_role_name               | The IAM Role name                                          |
| sqs_name                    | SQS Queue name                                             |
| sns_arn                     | SNS Topic ARN                                              |
