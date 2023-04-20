output "bucket_arn" {
  value       = local.bucket_arn
  description = "Lacework AWS EKS Audit Log S3 Bucket ARN"
}

output "bucket_name" {
  value       = local.bucket_name
  description = "Lacework AWS EKS Audit Log S3 Bucket name"
}

output "filter_prefix" {
  value       = "${var.prefix}-${random_id.uniq.hex}-eks-cw-"
  description = "The Cloudwatch Log Subscription filter prefix"
}

output "cloudwatch_iam_role_arn" {
  value       = local.cloudwatch_iam_role_arn
  description = "The Cloudwatch IAM Role ARN"
}

output "cloudwatch_iam_role_name" {
  value       = trimprefix(data.aws_arn.cloudwatch_iam_role.resource, "role/")
  description = "The Cloudwatch IAM Role name"
}

output "cross_account_iam_role_name" {
  value       = trimprefix(data.aws_arn.iam_role.resource, "role/")
  description = "The Cross Account IAM Role name"
}

output "cross_account_iam_role_arn" {
  value       = local.iam_role_arn
  description = "The Cross Account IAM Role ARN"
}

output "external_id" {
  value       = local.iam_role_external_id
  description = "The External ID configured into the IAM role"
}

output "filter_pattern" {
  value       = var.filter_pattern
  description = "The Cloudwatch Log Subscription Filter pattern"
}

output "firehose_arn" {
  value       = aws_kinesis_firehose_delivery_stream.extended_s3_stream.arn
  description = "The Firehose delivery stream ARN"
}

output "firehose_iam_role_arn" {
  value       = local.firehose_iam_role_arn
  description = "The Firehose IAM Role ARN"
}

output "firehose_iam_role_name" {
  value       = trimprefix(data.aws_arn.firehose_iam_role.resource, "role/")
  description = "The Firehose IAM Role name"
}

output "sns_arn" {
  value       = aws_sns_topic.eks_sns_topic.arn
  description = "SNS Topic ARN"
}

output "sns_name" {
  value       = aws_sns_topic.eks_sns_topic.name
  description = "SNS Topic name"
}

