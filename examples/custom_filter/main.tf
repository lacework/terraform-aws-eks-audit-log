provider "lacework" {}

module "aws_eks_audit_log" {
  source = "../.."

  cloudwatch_regions = ["us-west-1"]
  cluster_names      = ["example_cluster"]
  filter_pattern = join(" ",
    ["{",
      "($.responseStatus.code != 200 ||",
      "$.objectRef.resource != \"leases\" ||",
      "$.verb != \"update\" ||",
      "$.user.username != \"system:*\") &&",

      "($.responseStatus.code != 200 ||",
      "$.objectRef.resource != \"configmaps\" ||",
      "$.verb != \"watch\" ||",
      "$.user.username != \"system:node:*\") &&",

      "($.responseStatus.code != 200 ||",
      "$.objectRef.resource != \"configmaps\" ||",
      "$.verb != \"update\" ||",
      "($.user.username != \"system:serviceaccounts:*\" &&",
      "$.user.username != \"system:eks:certificate-controller\")) &&",

      "($.responseStatus.code != 200 ||",
      "$.objectRef.resource != \"endpoints\" ||",
      "$.verb != \"update\" ||",
      "($.user.username != \"system:serviceaccounts:*\" &&",
      "$.user.username != \"system:eks:certificate-controller\"))",

    "}"]
  )
}
