provider "lacework" {}

module "aws_eks_audit_log" {
  source = "../.."

  cloudwatch_regions  = ["us-west-2"]
  cluster_names       = ["example_cluster"]
  allow_debugging_permissions = true
}
