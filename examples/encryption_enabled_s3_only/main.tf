provider "lacework" {}

provider "aws" {
  region = "us-west-2"
}

module "aws_eks_audit_log" {
  source = "../.."

  cloudwatch_regions                  = ["us-west-2"]
  cluster_names                       = ["my-tf-cluster"]
  kinesis_firehose_encryption_enabled = false
  sns_topic_encryption_enabled        = false
}
