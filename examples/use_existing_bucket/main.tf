provider "lacework" {}

module "aws_eks_audit_log" {
  source = "../.."

  cloudwatch_regions  = ["us-west-2"]
  cluster_names       = ["example_cluster"]
  use_existing_bucket = true
  bucket_arn          = "arn:aws:s3:::dev5-cloud-account-registrar-lacework"
}
