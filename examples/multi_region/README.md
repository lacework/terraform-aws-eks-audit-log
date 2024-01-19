# Integrate EKS cluster(s) Audit Logs with Lacework - Multi-region

This example creates all the required resources, as well as an IAM Role with a cross-account policy to 
provide Lacework read-only access to monitor the audit logs.

Additionally, this example creates multiple aws providers with an alias to create Cloudwatch Subscription filters 
across multiple regions.

## Inputs

| Name                        | Description                                                                                     | Type           |
| --------------------------- | ----------------------------------------------------------------------------------------------- | -------------- |
| `cloudwatch_regions`        | A list of regions, to allow Cloudwatch Logs to be streamed from                                 | `list(string)` |
| `no_cw_subscription_filter` | Set to true to create an integration with no Cloudwatch Subscription filter for your cluster(s) | `bool`         |

## Sample Code

```terraform
provider "lacework" {}

provider "aws" {
  region = "eu-west-1"
  alias  = "eu-west-1"
}

provider "aws" {
  region = "us-west-2"
  alias  = "us-west-2"
}

module "aws_eks_audit_log" {
  source  = "lacework/eks-audit-log/aws"
  version = "~> 0.2"

  cloudwatch_regions        = ["eu-west-1", "us-west-2"]
  no_cw_subscription_filter = true
}

resource "aws_cloudwatch_log_subscription_filter" "lacework_cw_subscription_filter-eu-west" {
  for_each = toset(["cluster-1", "cluster-2"])
  provider = aws.eu-west-1

  name            = "${module.aws_eks_audit_log.filter_prefix}-${each.value}"
  role_arn        = module.aws_eks_audit_log.cloudwatch_iam_role_arn
  log_group_name  = "/aws/eks/${each.value}/cluster"
  filter_pattern  = module.aws_eks_audit_log.filter_pattern
  destination_arn = module.aws_eks_audit_log.firehose_arn
  depends_on      = [module.aws_eks_audit_log]
}

resource "aws_cloudwatch_log_subscription_filter" "lacework_cw_subscription_filter-us-west-2" {
  for_each = toset(["cluster-3"])
  provider = aws.us-west-2

  name            = "${module.aws_eks_audit_log.filter_prefix}-${each.value}"
  role_arn        = module.aws_eks_audit_log.cloudwatch_iam_role_arn
  log_group_name  = "/aws/eks/${each.value}/cluster"
  filter_pattern  = module.aws_eks_audit_log.filter_pattern
  destination_arn = module.aws_eks_audit_log.firehose_arn
  depends_on      = [module.aws_eks_audit_log]
}
```

## Things to note
Due to limitations on the `aws_cloudwatch_log_subscription_filter` resource, to make this integration multi-region, 
we must move the creation of the `aws_cloudwatch_log_subscription_filter` resources to the top level and additionally 
create an AWS provider for each region.

You should create an AWS provider for each region that has a cluster that you wish to integrate. e.g.

```terraform
provider "aws" {
  region = "us-west-2"
  alias  = "us-west-2"
}
```

When declaring the `aws_cloudwatch_log_subscription_filter` resource for each region, the only fields that need to be 
changed in comparison to the above example are:
- the list of clusters within the `for_each` assignment. Note the `toset()` function is required when using a list of strings with `for_each`.
- the provider to be used. Set this to the region which the cluster(s) are deployed.

e.g.

```terraform
resource "aws_cloudwatch_log_subscription_filter" "lacework_cw_subscription_filter-us-west-2" {
  // the following variables require input
  for_each = toset(["<list of clusters>"])
  provider = aws.your_region_aliased_provider

  // leave the following variables as is
  name            = "${module.aws_eks_audit_log.filter_prefix}-${each.value}"
  role_arn        = module.aws_eks_audit_log.cloudwatch_iam_role_arn
  log_group_name  = "/aws/eks/${each.value}/cluster"
  filter_pattern  = module.aws_eks_audit_log.filter_pattern
  destination_arn = module.aws_eks_audit_log.firehose_arn
  depends_on      = [module.aws_eks_audit_log]
}
```

For detailed information on integrating Lacework with AWS EKS Audit Logs see [AWS EKS Audit Log Integration with Terraform](https://docs.lacework.net/onboarding/eks-audit-log-integration-with-terraform).
