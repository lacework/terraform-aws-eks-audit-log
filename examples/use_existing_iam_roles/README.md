# Integrate EKS cluster(s) Audit Logs with Lacework - Use Existing IAM Roles

This is an example of the EKS audit logs module using existing IAM roles for cross-account, cloudwatch,
and kinesis firehose. This assumes that the existing IAM roles have the right trust and policies attached
prior to use. 

## Inputs

| Name                                  | Description                                                                                               | Type           |
| ------------------------------------- | --------------------------------------------------------------------------------------------------------- | -------------- |
| `cloudwatch_regions`                  | A list of regions, to allow Cloudwatch Logs to be streamed from                                           | `list(string)` |
| `cluster_names`                       | A set of cluster names, to integrate with. Defaults to [] if `no_cw_subscription_filter` is set to `true` | `bool`         |
| `use_existing_cross_account_iam_role` | Set this to true to use an existing IAM role for cross-account access                                     | `bool`         |
| `iam_role_arn`                        | IAM role arn to use for cross-account access if use_existing_cross_account_iam_role is set to true        | `string`       |
| `iam_role_external_id`                | External ID for the cross-account IAM role if use_existing_cross_account_iam_role is set to true          | `string`       |
| `use_existing_cloudwatch_iam_role`    | Set this to true to use an existing IAM role for the Cloudwatch subscription filter                       | `bool`         |
| `cloudwatch_iam_role_arn`             | IAM role arn to use for the Cloudwatch filter if use_existing_cloudwatch_iam_role is set to true          | `string`       |
| `use_existing_firehose_iam_role`      | Set this to true to use an existing IAM role for the Kinesis Firehose                                     | `bool`         |
| `firehose_iam_role_arn`               | IAM role arn to use for the Kinesis Firehose if use_existing_firehose_iam_role is set to true             | `string`       |

## Sample Code

```terraform
provider "lacework" {}

module "aws_eks_audit_log" {
  source  = "lacework/eks-audit-log/aws"
  version = "~> 0.4"

  cloudwatch_regions                  = ["us-west-1"]
  cluster_names                       = ["example_cluster"]
  use_existing_cross_account_iam_role = true
  iam_role_arn                        = "arn:aws:iam::123456789012:role/my-ca-role"
  iam_role_external_id                = "abc123"
  use_existing_cloudwatch_iam_role    = true
  cloudwatch_iam_role_arn             = "arn:aws:iam::123456789012:role/my-cw-role"
  use_existing_firehose_iam_role      = true
  firehose_iam_role_arn               = "arn:aws:iam::123456789012:role/my-fh-role"
}
```

For detailed information on integrating Lacework with AWS EKS Audit Logs see [AWS EKS Audit Log Integration with Terraform](https://docs.lacework.com/aws-eks-audit-log-integration-with-terraform).
