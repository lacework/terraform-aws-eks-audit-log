output "bucket_arn" {
  value       = aws_s3_bucket.eks_audit_log_bucket.arn
  description = "Lacework AWS EKS Audit Log S3 Bucket ARN"
}

output "bucket_name" {
  value       = local.bucket_name
  description = "Lacework AWS EKS Audit Log S3 Bucket name"
}

output "sns_arn" {
  value       = aws_sns_topic.eks_sns_topic.arn
  description = "SNS Topic ARN"
}

output "sns_name" {
  value       = aws_sns_topic.eks_sns_topic.name
  description = "SNS Topic name"
}

output "external_id" {
  value       = local.iam_role_external_id
  description = "The External ID configured into the IAM role"
}

output "cross_account_iam_role_name" {
  value       = module.lacework_eks_audit_iam_role.name
  description = "The Cross Account IAM Role name"
}

output "firehose_arn" {
  value       = aws_kinesis_firehose_delivery_stream.extended_s3_stream.arn
  description = "The Firehose IAM Role name"
}

output "firehose_iam_role_name" {
  value       = aws_iam_role.firehose_iam_role.name
  description = "The Firehose IAM Role name"
}

output "cloudwatch_iam_role_name" {
  value       = aws_iam_role.eks_cw_iam_role.name
  description = "The Cloudwatch IAM Role name"
}

output "cloudwatch_iam_role_arn" {
  value       = aws_iam_role.eks_cw_iam_role.arn
  description = "The Cloudwatch IAM Role arn"
}

output "iam_role_arn" {
  value       = local.iam_role_arn
  description = "The IAM Role ARN"
}

output "cluster_prefix" {
  value = "${var.prefix}-${random_id.uniq.hex}-eks-cw-"
}

output "filter_pattern" {
  value = "{ $.stage = \"ResponseComplete\" && $.requestURI != \"/version\" && $.requestURI != \"/version?*\" && $.requestURI != \"/metrics\" && $.requestURI != \"/metrics?*\" && $.requestURI != \"/logs\" && $.requestURI != \"/logs?*\" && $.requestURI != \"/swagger*\" && $.requestURI != \"/livez*\" && $.requestURI != \"/readyz*\" && $.requestURI != \"/healthz*\" }"

}

