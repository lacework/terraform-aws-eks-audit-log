provider "lacework" {}

module "aws_eks_audit_log" {
  source = "../.."
  cluster_names = ["test_cluster"]
  cloudwatch_region = "us-west-2"
}
