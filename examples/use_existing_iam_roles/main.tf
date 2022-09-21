provider "lacework" {}

module "aws_eks_audit_log" {
  source                              = "../.."
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
