provider "lacework" {}

provider "aws" {
  region = "us-west-2"
}

module "aws_eks_audit_log" {
  source                    = "../.."
  cloudwatch_regions        = ["us-west-2"]
  cluster_name              = ["my-tf-cluster"]
}
