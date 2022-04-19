locals {
  bucket_name                     = "${var.prefix}${random_id.uniq.hex}"
  mfa_delete                      = var.bucket_versioning_enabled && var.bucket_enable_mfa_delete ? "Enabled" : "Disabled"
  bucket_versioning_enabled       = var.bucket_versioning_enabled ? "Enabled" : "Suspended"
  cross_account_policy_name       = "${var.prefix}-cross-acct-policy-${random_id.uniq.hex}"
  iam_role_arn                    = module.lacework_eks_audit_iam_role.arn
  iam_role_external_id            = module.lacework_eks_audit_iam_role.external_id
  cross_account_iam_role_name     = "${var.prefix}-ca-${random_id.uniq.hex}"
  sns_name                        = "${var.prefix}${random_id.uniq.hex}"
  firehose_iam_role_name          = "${var.prefix}-fh-${random_id.uniq.hex}"
  firehose_policy_name            = "${var.prefix}-fh-policy-${random_id.uniq.hex}"
  firehose_delivery_stream_name   = "${var.prefix}${random_id.uniq.hex}"
  eks_cw_iam_role_name            = "${var.prefix}-cw-${random_id.uniq.hex}"
  cw_iam_policy_name              = "${var.prefix}-cw-policy-${random_id.uniq.hex}"
  cloudwatch_permission_resources = "arn:aws:logs:*:${data.aws_caller_identity.current.account_id}:log-group:/aws/eks/*:*"
  log_regions                     = [for region in var.cloudwatch_regions : "logs.${region}.amazonaws.com"]
  cluster_names                   = var.no_cw_subscription_filter ? [] : var.cluster_names
}

resource "random_id" "uniq" {
  byte_length = 4
}

resource "aws_sns_topic" "eks_sns_topic" {
  name = local.sns_name
}

resource "aws_sns_topic_policy" "eks_sns_topic_policy" {
  arn = aws_sns_topic.eks_sns_topic.arn

  policy = data.aws_iam_policy_document.eks_sns_topic_policy.json
}

# we need the identity of the caller to get their account_id
data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "eks_sns_topic_policy" {

  statement {
    sid    = "AllowLaceworkToSubscribe"
    effect = "Allow"
    principals {
      identifiers = ["arn:aws:iam::${var.lacework_aws_account_id}:root"]
      type        = "AWS"
    }
    actions = [
      "sns:Subscribe"
    ]
    resources = [
      aws_sns_topic.eks_sns_topic.arn
    ]
  }

  statement {
    sid = "AllowS3ToPublish"
    actions = [
      "sns:Publish",
    ]
    resources = [
      aws_sns_topic.eks_sns_topic.arn
    ]
    condition {
      test     = "StringEquals"
      variable = "AWS:SourceAccount"

      values = [
        data.aws_caller_identity.current.account_id,
      ]
    }
    condition {
      test     = "ArnLike"
      variable = "AWS:SourceArn"

      values = [
        "arn:aws:s3:*:*:${local.bucket_name}",
      ]
    }

    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["s3.amazonaws.com"]
    }
  }
}

resource "aws_s3_bucket" "eks_audit_log_bucket" {
  bucket        = local.bucket_name
  force_destroy = var.bucket_force_destroy
  tags          = var.tags
}

resource "aws_s3_bucket_lifecycle_configuration" "eks_audit_log_bucket_lifecycle_config" {
  bucket = aws_s3_bucket.eks_audit_log_bucket.id

  rule {
    id = "eks_audit_log_expiration"
    expiration {
      days = var.bucket_lifecycle_expiration_days
    }
    status = "Enabled"
  }
}

// v4 s3 bucket changes
resource "aws_s3_bucket_versioning" "export__versioning" {
  bucket = aws_s3_bucket.eks_audit_log_bucket.id
  versioning_configuration {
    status     = local.bucket_versioning_enabled
    mfa_delete = local.mfa_delete
  }
}

resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = aws_s3_bucket.eks_audit_log_bucket.id

  topic {
    topic_arn     = aws_sns_topic.eks_sns_topic.arn
    events        = ["s3:ObjectCreated:*"]
    filter_prefix = "eks_audit_logs/${data.aws_caller_identity.current.account_id}"
  }
  depends_on = [aws_sns_topic.eks_sns_topic, aws_sns_topic_policy.eks_sns_topic_policy]
}

resource "aws_iam_role" "firehose_iam_role" {
  name               = local.firehose_iam_role_name
  assume_role_policy = data.aws_iam_policy_document.firehose_iam_assume_role_policy.json
}

data "aws_iam_policy_document" "firehose_iam_assume_role_policy" {
  version = "2012-10-17"

  statement {
    sid     = "LaceworkEKSFirehoseIAMRole"
    actions = ["sts:AssumeRole"]
    effect  = "Allow"
    principals {
      type        = "Service"
      identifiers = ["firehose.amazonaws.com"]
    }
  }
}

resource "aws_iam_policy" "firehose_iam_policy" {
  name        = local.firehose_policy_name
  description = "A firehose IAM policy"
  policy      = data.aws_iam_policy_document.firehose_iam_role_policy.json
}

resource "aws_iam_role_policy_attachment" "firehose_iam_role_policy" {
  role       = local.firehose_iam_role_name
  policy_arn = aws_iam_policy.firehose_iam_policy.arn
  depends_on = [aws_iam_policy.firehose_iam_policy]
}

data "aws_iam_policy_document" "firehose_iam_role_policy" {
  version = "2012-10-17"

  statement {
    sid = "LaceworkEKSFirehoseIAMRole"
    actions = [
      "s3:AbortMultipartUpload",
      "s3:GetBucketLocation",
      "s3:GetObject",
      "s3:ListBucket",
      "s3:ListBucketMultipartUploads",
      "s3:PutObject",
    ]
    effect    = "Allow"
    resources = ["${aws_s3_bucket.eks_audit_log_bucket.arn}/*"]
  }
}

resource "aws_kinesis_firehose_delivery_stream" "extended_s3_stream" {
  name        = local.firehose_delivery_stream_name
  destination = "extended_s3"

  extended_s3_configuration {
    role_arn            = aws_iam_role.firehose_iam_role.arn
    bucket_arn          = aws_s3_bucket.eks_audit_log_bucket.arn
    prefix              = "eks_audit_logs/${data.aws_caller_identity.current.account_id}/"
    buffer_interval     = 300
    buffer_size         = 100
    error_output_prefix = "audit_logs/${data.aws_caller_identity.current.account_id}/error/"
    compression_format  = "UNCOMPRESSED"
    cloudwatch_logging_options {
      enabled = false
    }
  }
  server_side_encryption {
    enabled = false
  }
  depends_on = [aws_s3_bucket.eks_audit_log_bucket, aws_iam_role.firehose_iam_role]
}

module "lacework_eks_audit_iam_role" {
  source                  = "lacework/iam-role/aws"
  version                 = "~> 0.1"
  create                  = true
  iam_role_name           = local.cross_account_iam_role_name
  lacework_aws_account_id = var.lacework_aws_account_id
  external_id_length      = var.external_id_length
  tags                    = var.tags
}

resource "aws_iam_policy" "eks_cross_account_policy" {
  name        = local.cross_account_policy_name
  description = "A cross account policy to allow Lacework to write to pull eks audit logs"
  policy      = data.aws_iam_policy_document.eks_cross_account_policy.json
}

resource "aws_iam_role_policy_attachment" "eks_cross_account_role_policy" {
  role       = local.cross_account_iam_role_name
  policy_arn = aws_iam_policy.eks_cross_account_policy.arn
  depends_on = [module.lacework_eks_audit_iam_role]
}

data "aws_iam_policy_document" "eks_cross_account_policy" {
  version = "2012-10-17"

  statement {
    sid = "S3Permissions"
    actions = [
      "s3:Get*",
      "s3:ListBucket",
      "s3:ListObjectsV2"
    ]
    effect = "Allow"
    resources = [
      aws_s3_bucket.eks_audit_log_bucket.arn,
      "${aws_s3_bucket.eks_audit_log_bucket.arn}/*"
    ]
  }

  statement {
    sid = "CloudWatchLogsPermissions"
    actions = [
      "logs:DescribeSubscriptionFilters",
      "logs:PutSubscriptionFilter"
    ]
    effect    = "Allow"
    resources = [local.cloudwatch_permission_resources]
  }

  statement {
    sid = "IAMPermissions"
    actions = [
      "iam:GetRole",
      "iam:PassRole"
    ]
    effect    = "Allow"
    resources = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/*${var.prefix}-eks-cw*"]
  }

  statement {
    sid = "SNSPermissions"
    actions = [
      "sns:GetTopicAttributes",
      "sns:Subscribe",
      "sns:Unsubscribe"
    ]
    effect    = "Allow"
    resources = [aws_sns_topic.eks_sns_topic.arn]
  }

  statement {
    sid = "FirehosePermissions"
    actions = [
      "firehose:DescribeDeliveryStream"
    ]
    effect    = "Allow"
    resources = [aws_kinesis_firehose_delivery_stream.extended_s3_stream.arn]
  }

  statement {
    sid       = "AccountAliasPermissions"
    actions   = ["iam:ListAccountAliases"]
    effect    = "Allow"
    resources = ["*"]
  }

  statement {
    sid       = "Debug"
    resources = ["*"]
    effect    = "Allow"
    actions = [
      "eks:ListClusters",
      "logs:DescribeLogGroups",
      "firehose:ListDeliveryStreams",
      "sns:ListTopics",
      "s3:ListAllMyBuckets",
      "s3:GetBucketAcl",
      "s3:GetBucketLocation",
      "s3:GetBucketNotificationConfiguration",
      "cloudwatch:GetMetricData"
    ]
  }
}

resource "aws_iam_role" "eks_cw_iam_role" {
  name               = local.eks_cw_iam_role_name
  assume_role_policy = data.aws_iam_policy_document.eks_cw_assume_role_policy.json
  depends_on         = [module.lacework_eks_audit_iam_role, aws_iam_role_policy_attachment.eks_cross_account_role_policy]
}

data "aws_iam_policy_document" "eks_cw_assume_role_policy" {
  version = "2012-10-17"

  statement {
    sid     = "LaceworkEKSCloudWatchIAMRole"
    actions = ["sts:AssumeRole"]
    effect  = "Allow"
    principals {
      type        = "Service"
      identifiers = local.log_regions
    }
  }
}

resource "aws_iam_policy" "eks_cw_iam_policy" {
  name        = local.cw_iam_policy_name
  description = "EKS Cloudwatch IAM policy"
  policy      = data.aws_iam_policy_document.eks_cw_iam_role_policy.json
}

data "aws_iam_policy_document" "eks_cw_iam_role_policy" {
  version = "2012-10-17"

  statement {
    actions = [
      "firehose:*",
    ]
    effect    = "Allow"
    resources = ["arn:aws:firehose:*:${data.aws_caller_identity.current.account_id}:*"]
  }
}

resource "aws_iam_role_policy_attachment" "eks_cw_iam_role_policy" {
  role       = local.eks_cw_iam_role_name
  policy_arn = aws_iam_policy.eks_cw_iam_policy.arn
  depends_on = [aws_iam_role.eks_cw_iam_role, aws_iam_policy.eks_cw_iam_policy]
}

// for_each cluster, create a subscription filter
resource "aws_cloudwatch_log_subscription_filter" "lacework_eks_cw_subscription_filter" {
  for_each        = local.cluster_names
  name            = "${var.prefix}-${each.value}-eks-cw-${random_id.uniq.hex}"
  role_arn        = aws_iam_role.eks_cw_iam_role.arn
  log_group_name  = "/aws/eks/${each.value}/cluster"
  filter_pattern  = "{ $.stage = \"ResponseComplete\" && $.requestURI != \"/version\" && $.requestURI != \"/version?*\" && $.requestURI != \"/metrics\" && $.requestURI != \"/metrics?*\" && $.requestURI != \"/logs\" && $.requestURI != \"/logs?*\" && $.requestURI != \"/swagger*\" && $.requestURI != \"/livez*\" && $.requestURI != \"/readyz*\" && $.requestURI != \"/healthz*\" }"
  destination_arn = aws_kinesis_firehose_delivery_stream.extended_s3_stream.arn
  depends_on      = [aws_iam_role.eks_cw_iam_role, aws_kinesis_firehose_delivery_stream.extended_s3_stream]
}

# wait for X seconds for things to settle down in the AWS side
# before trying to create the Lacework external integration
resource "time_sleep" "wait_time_cw" {
  create_duration = var.wait_time
  depends_on = [
    aws_iam_role_policy_attachment.eks_cw_iam_role_policy
  ]
}

resource "lacework_integration_aws_eks_audit_log" "data_export" {
  name    = var.integration_name
  sns_arn = aws_sns_topic.eks_sns_topic.arn
  credentials {
    role_arn    = local.iam_role_arn
    external_id = local.iam_role_external_id
  }
  depends_on = [time_sleep.wait_time_cw]
}


