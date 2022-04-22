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
  source                    = "../.."
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
  for_each = toset(["cluster-3", "cluster-4"])
  provider = aws.us-west-2

  name            = "${module.aws_eks_audit_log.filter_prefix}-${each.value}"
  role_arn        = module.aws_eks_audit_log.cloudwatch_iam_role_arn
  log_group_name  = "/aws/eks/${each.value}/cluster"
  filter_pattern  = module.aws_eks_audit_log.filter_pattern
  destination_arn = module.aws_eks_audit_log.firehose_arn
  depends_on      = [module.aws_eks_audit_log]
}