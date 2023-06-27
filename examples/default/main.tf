provider "lacework" {}

module "aws_eks_audit_log" {
  source = "../.."

  cloudwatch_regions = ["us-west-1"]
  cluster_names      = ["example_cluster"]
}
