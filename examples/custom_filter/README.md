# Integrate EKS cluster(s) Audit Logs with Lacework - Single Region

This example creates all the required resources, as well as an IAM Role with a cross-account policy to
provide Lacework read-only access to monitor the audit logs, and provides a custom filter to apply to these audit logs

## Inputs

| Name                 | Description                                                                                               | Type           |
|----------------------|-----------------------------------------------------------------------------------------------------------|----------------|
| `cloudwatch_regions` | A list of regions, to allow Cloudwatch Logs to be streamed from                                           | `list(string)` |
| `cluster_names`      | A set of cluster names, to integrate with. Defaults to [] if `no_cw_subscription_filter` is set to `true` | `set(string)`         |
| `filter_pattern`     | A string that details a filter pattern to apply when collecting audit logs                                | `string`       |

## Sample Code

```terraform
provider "lacework" {}

module "aws_eks_audit_log" {
  source  = "lacework/eks-audit-log/aws"
  version = "~> 0.2"

  cloudwatch_regions = ["us-west-1"]
  cluster_names      = ["example_cluster"]
  filter_pattern = join(" ",
    ["{",
      "($.responseStatus.code != 200 ||",
      "$.objectRef.resource != \"leases\" ||",
      "$.verb != \"update\" ||",
      "$.user.username != \"system:*\") &&",

      "($.responseStatus.code != 200 ||",
      "$.objectRef.resource != \"configmaps\" ||",
      "$.verb != \"watch\" ||",
      "$.user.username != \"system:node:*\") &&",

      "($.responseStatus.code != 200 ||",
      "$.objectRef.resource != \"configmaps\" ||",
      "$.verb != \"update\" ||",
      "($.user.username != \"system:serviceaccounts:*\" &&",
      "$.user.username != \"system:eks:certificate-controller\")) &&",

      "($.responseStatus.code != 200 ||",
      "$.objectRef.resource != \"endpoints\" ||",
      "$.verb != \"update\" ||",
      "($.user.username != \"system:serviceaccounts:*\" &&",
      "$.user.username != \"system:eks:certificate-controller\"))",

    "}"]
  )
}
```

For detailed information on integrating Lacework with AWS EKS Audit Logs see [AWS EKS Audit Log Integration with Terraform](https://docs.lacework.com/aws-eks-audit-log-integration-with-terraform).
