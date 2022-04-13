provider "lacework" {}

provider "aws" {
  region = "eu-west-1"
  alias = "eu-west-1"
}

provider "aws" {
  region = "us-west-2"
  alias = "us-west-2"
}

module "aws_eks_audit_log" {
  source = "../.."
  cloudwatch_regions = ["eu-west-1", "us-west-2"]
}

resource "aws_cloudwatch_log_subscription_filter" "lacework_eks_cw_subscription_filter-eu-west" {
  for_each        = toset(["cluster-aic7NmW6", "ross_test_cluster"])
  name            = "${module.aws_eks_audit_log.cluster_prefix}-${each.value}"
  role_arn        = module.aws_eks_audit_log.cloudwatch_iam_role_arn
  log_group_name  = "/aws/eks/${each.value}/cluster"
  filter_pattern  = module.aws_eks_audit_log.filter_pattern
  destination_arn = module.aws_eks_audit_log.firehose_arn
  depends_on      = [module.aws_eks_audit_log]
  provider = aws.eu-west-1
}

resource "aws_cloudwatch_log_subscription_filter" "lacework_eks_cw_subscription_filter" {
  for_each        = toset(["ross_test_2"])
  name            = "${module.aws_eks_audit_log.cluster_prefix}-${each.value}"
  role_arn        = module.aws_eks_audit_log.cloudwatch_iam_role_arn
  log_group_name  = "/aws/eks/${each.value}/cluster"
  filter_pattern  = module.aws_eks_audit_log.filter_pattern
  destination_arn = module.aws_eks_audit_log.firehose_arn
  depends_on      = [module.aws_eks_audit_log]
  provider = aws.us-west-2
}