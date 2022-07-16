# Integrate EKS cluster(s) Audit Logs with Lacework - Encryption Enabled on S3 Only

This example creates all the required resources, as well as an IAM Role with a cross-account policy to 
provide Lacework read-only access to monitor the audit logs.

Additionally, this example encrypts the Kinesis Firehose, S3 Bucket, and SNS Topic with a preexisting KMS key.

## Inputs

| Name                                  | Description                                                                                                                               | Type           |
| ------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------- | -------------- |
| `cloudwatch_regions`                  | A list of regions, to allow Cloudwatch Logs to be streamed from                                                                           | `list(string)` |
| `cluster_names`                       | A set of cluster names, to integrate with. Defaults to [] if `no_cw_subscription_filter` is set to `true`                                 | `set(string)`  |
| `bucket_sse_key_arn`                  | The ARN of the KMS encryption key to be used for S3 (Required when `bucket_sse_algorithm` is `aws:kms` and using an existing aws_kms_key) | `string` | 
| `kinesis_firehose_encryption_key_arn` | The ARN of an existing KMS encryption key to be used for the Kinesis Firehose                                                             | `string`         |
| `sns_topic_encryption_key_arn`        | The ARN of an existing KMS encryption key to be used for the SNS topic                                                                    | `string`         |

## Sample Code

```terraform
provider "lacework" {}

provider "aws" {
  region = "us-west-2"
}

module "aws_eks_audit_log" {
  source                              = "lacework/eks-audit-log/aws"
  version                             = "~> 0.2"
  cloudwatch_regions                  = ["us-west-2"]
  cluster_names                       = ["my-tf-cluster"]
  bucket_sse_key_arn                  = "arn:aws:kms:us-west-2:123456789012:key/mrk-1234567890abcdefghijklmnopqrstuv"
  kinesis_firehose_encryption_key_arn = "arn:aws:kms:us-west-2:123456789012:key/mrk-1234567890abcdefghijklmnopqrstuv"
  sns_topic_encryption_key_arn        = "arn:aws:kms:us-west-2:123456789012:key/mrk-1234567890abcdefghijklmnopqrstuv"
}
```

## Things to note
When an ARN is supplied for either the Firehose, bucket, or topic, the module will use the supplied KMS key.

If one (or two) of the three resouces doesn't use a supplied/existing key, a KMS key will be created and that resource(s) will use the KMS key created. So it is possible to use both a created and an existing key.
