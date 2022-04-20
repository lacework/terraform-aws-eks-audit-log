# Integrate EKS cluster(s) Audit Logs with Lacework - Single Region

This example creates all the required resources, as well as an IAM Role with a cross-account policy to
provide Lacework read-only access to monitor the audit logs.

## Inputs

| Name                        | Description                                                                                               | Type           |
| --------------------------- | --------------------------------------------------------------------------------------------------------- | -------------- |
| `cloudwatch_regions`        | A list of regions, to allow Cloudwatch Logs to be streamed from                                           | `list(string)` |
| `cluster_names`             | A set of cluster names, to integrate with. Defaults to [] if `no_cw_subscription_filter` is set to `true` | `bool`         |

## Sample Code

```terraform
provider "lacework" {}

module "aws_eks_audit_log" {
  source             = "../.."
  cloudwatch_regions = ["us-west-1"]
  cluster_names      = ["example_cluster"]
}
```

For detailed information on integrating Lacework with AWS EKS Audit Logs see [AWS EKS Audit Log Integration with Terraform](https://support.lacework.com/hc/??????).
