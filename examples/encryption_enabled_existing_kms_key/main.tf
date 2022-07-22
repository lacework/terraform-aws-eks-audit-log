provider "lacework" {}

provider "aws" {
  region = "us-west-2"
}

module "aws_eks_audit_log" {
  source                              = "../.."
  cloudwatch_regions                  = ["us-west-2"]
  cluster_names                       = ["my-tf-cluster"]
  bucket_sse_key_arn                  = "arn:aws:kms:us-west-2:123456789012:key/mrk-1234567890abcdefghijklmnopqrstuv"
  kinesis_firehose_encryption_key_arn = "arn:aws:kms:us-west-2:123456789012:key/mrk-1234567890abcdefghijklmnopqrstuv"
  sns_topic_encryption_key_arn        = "arn:aws:kms:us-west-2:123456789012:key/mrk-1234567890abcdefghijklmnopqrstuv"
}
