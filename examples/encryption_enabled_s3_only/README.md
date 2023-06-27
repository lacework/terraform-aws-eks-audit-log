# Integrate EKS cluster(s) Audit Logs with Lacework - Encryption Enabled on S3 Only

This example creates all the required resources, as well as an IAM Role with a cross-account policy to 
provide Lacework read-only access to monitor the audit logs.

Additionally, this example encrypts the S3 Bucket only, the Kinesis Firehose and SNS Topic are not. A KMS key is generated.

## Inputs

| Name                                  | Description                                                                                               | Type           |
| ------------------------------------- | --------------------------------------------------------------------------------------------------------- | -------------- |
| `cloudwatch_regions`                  | A list of regions, to allow Cloudwatch Logs to be streamed from                                           | `list(string)` |
| `cluster_names`                       | A set of cluster names, to integrate with. Defaults to [] if `no_cw_subscription_filter` is set to `true` | `set(string)`  |
| `kinesis_firehose_encryption_enabled` | Set this to `false` to disable encryption on the Kinesis Firehose. Defaults to `true`                     | `bool`         |
| `sns_topic_encryption_enabled`        | Set this to `false` to disable encryption on the sns topic. Defaults to `true`                            | `bool`         |

## Sample Code

```terraform
provider "lacework" {}

provider "aws" {
  region = "us-west-2"
}

module "aws_eks_audit_log" {
  source  = "lacework/eks-audit-log/aws"
  version = "~> 0.3"

  cloudwatch_regions                  = ["us-west-2"]
  cluster_names                       = ["my-tf-cluster"]
  kinesis_firehose_encryption_enabled = false
  sns_topic_encryption_enabled        = false
}
```

## Things to note
With the default settings, the module will create a new KMS key and use it to encrypt the S3 Bucket.
