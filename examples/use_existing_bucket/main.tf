provider "lacework" {}

# Configure the AWS Provider
provider "aws" {}


module "aws_eks_audit_log" {
  source = "../.."

  cloudwatch_regions  = ["us-west-2"]
  no_cw_subscription_filter = true
  cluster_names       = []
  use_existing_bucket = true
  tags                = { Name = "my-test-tag-1"}
  bucket_arn          = "arn:aws:s3:::dmct-2320-2-laceworkcws-8f04"
}
