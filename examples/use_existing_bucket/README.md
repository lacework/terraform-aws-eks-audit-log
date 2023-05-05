# Integrate EKS cluster(s) Audit Logs with Lacework - S3 Bucket Supplied

This example uses an existing S3 Bucket for storage, it creates all the other required resources, as well as an IAM Role 
with a cross-account policy to provide Lacework read-only access to monitor the audit logs.

## Inputs

| Name                        | Description                                                                                               | Type           |
| --------------------------- | --------------------------------------------------------------------------------------------------------- | -------------- |
| `cloudwatch_regions`        | A list of regions, to allow Cloudwatch Logs to be streamed from                                           | `list(string)` |
| `cluster_names`             | A set of cluster names, to integrate with. Defaults to [] if `no_cw_subscription_filter` is set to `true` | `bool`         |
| `use_existing_bucket`       | Set this to `true` to use an existing S3 Bucket                                                           | `bool`         |
| `bucket_arn`                | The ARN of the existing S3 Bucket that will be used                                                       | `string`       |

## Sample Code

```terraform
provider "lacework" {}

module "aws_eks_audit_log" {
  source              = "lacework/eks-audit-log/aws"
  version             = "~> 0.5"
  cloudwatch_regions  = ["us-west-1"]
  cluster_names       = ["example_cluster"]
  use_existing_bucket = true
  bucket_arn          = "arn:aws:s3:::lacework-eks-bucket-8805c0bf"
}
```

For detailed information on integrating Lacework with AWS EKS Audit Logs see [AWS EKS Audit Log Integration with Terraform](https://docs.lacework.com/aws-eks-audit-log-integration-with-terraform).
