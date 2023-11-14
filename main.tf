locals {

  trimmed_bucket_arn = var.use_existing_bucket ? trimsuffix(var.bucket_arn, "/") : ""
  bucket_arn         = var.use_existing_bucket ? local.trimmed_bucket_arn : aws_s3_bucket.eks_audit_log_bucket[0].arn
  split_bucket_arn   = var.use_existing_bucket ? split(":", local.trimmed_bucket_arn) : []
  bucket_name        = var.use_existing_bucket ? element(local.split_bucket_arn, (length(local.split_bucket_arn) - 1)) : "${var.prefix}${random_id.uniq.hex}"

  log_bucket_name                     = length(var.log_bucket_name) > 0 ? var.log_bucket_name : "${local.bucket_name}-access-logs"
  mfa_delete                          = var.bucket_versioning_enabled && var.bucket_enable_mfa_delete ? "Enabled" : "Disabled"
  bucket_versioning_enabled           = var.bucket_versioning_enabled ? "Enabled" : "Suspended"
  cross_account_policy_name           = "${var.prefix}-cross-acct-policy-${random_id.uniq.hex}"
  iam_role_arn                        = var.use_existing_cross_account_iam_role ? var.iam_role_arn : module.lacework_eks_audit_iam_role[0].arn
  iam_role_external_id                = var.use_existing_cross_account_iam_role ? var.iam_role_external_id : module.lacework_eks_audit_iam_role[0].external_id
  cross_account_iam_role_name         = "${var.prefix}-ca-${random_id.uniq.hex}"
  sns_name                            = "${var.prefix}${random_id.uniq.hex}"
  firehose_iam_role_name              = "${var.prefix}-fh-${random_id.uniq.hex}"
  firehose_iam_role_arn               = var.use_existing_firehose_iam_role ? var.firehose_iam_role_arn : aws_iam_role.firehose_iam_role[0].arn
  firehose_policy_name                = "${var.prefix}-fh-policy-${random_id.uniq.hex}"
  firehose_delivery_stream_name       = "${var.prefix}${random_id.uniq.hex}"
  eks_cw_iam_role_name                = "${var.prefix}-cw-${random_id.uniq.hex}"
  cw_iam_policy_name                  = "${var.prefix}-cw-policy-${random_id.uniq.hex}"
  cloudwatch_permission_resources     = "arn:aws:logs:*:${data.aws_caller_identity.current.account_id}:log-group:/aws/eks/*:*"
  cloudwatch_iam_role_arn             = var.use_existing_cloudwatch_iam_role ? var.cloudwatch_iam_role_arn : aws_iam_role.eks_cw_iam_role[0].arn
  log_regions                         = [for region in var.cloudwatch_regions : "logs.${region}.amazonaws.com"]
  cluster_names                       = var.no_cw_subscription_filter ? [] : var.cluster_names
  create_kms_key                      = ((var.bucket_encryption_enabled && length(var.bucket_key_arn) == 0) || (var.sns_topic_encryption_enabled && length(var.sns_topic_key_arn) == 0) || (var.kinesis_firehose_encryption_enabled && length(var.kinesis_firehose_key_arn) == 0)) ? 1 : 0 #create KMS key if one of the resources should be encrypted and no ARN has been provided
  kms_key_alias                       = "alias/${var.prefix}-key-${random_id.uniq.hex}"
  bucket_encryption_enabled           = var.bucket_encryption_enabled
  bucket_key_arn                      = var.bucket_encryption_enabled ? (length(var.bucket_key_arn) > 0 ? var.bucket_key_arn : aws_kms_key.lacework_eks_kms_key[0].arn) : ""
  sns_topic_key_arn                   = var.sns_topic_encryption_enabled ? (length(var.sns_topic_key_arn) > 0 ? var.sns_topic_key_arn : aws_kms_key.lacework_eks_kms_key[0].arn) : ""
  kinesis_firehose_key_arn            = var.kinesis_firehose_encryption_enabled ? (length(var.kinesis_firehose_key_arn) > 0 ? var.kinesis_firehose_key_arn : aws_kms_key.lacework_eks_kms_key[0].arn) : ""
  kinesis_firehose_encryption_enabled = var.kinesis_firehose_encryption_enabled && length(local.kinesis_firehose_key_arn) > 0
}

resource "aws_kms_key" "lacework_eks_kms_key" {
  count                   = local.create_kms_key
  description             = "A KMS key used to encrypt EKS Audit logs which are monitored by Lacework"
  deletion_window_in_days = var.kms_key_deletion_days
  multi_region            = var.kms_key_multi_region
  tags                    = var.tags
  policy                  = data.aws_iam_policy_document.kms_key_policy.json
  enable_key_rotation     = var.kms_key_rotation
}

resource "aws_kms_alias" "lacework_eks_kms_alias" {
  count         = local.create_kms_key
  name          = local.kms_key_alias
  target_key_id = aws_kms_key.lacework_eks_kms_key[0].key_id
}

data "aws_iam_policy_document" "kms_key_policy" {
  version = "2012-10-17"

  statement {
    sid    = "Enable account root to use/manage KMS key"
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }
    actions   = ["kms:*"]
    resources = ["*"]
  }

  statement {
    sid    = "Allow Kinesis Firehose to use KMS key when bucket is encrypted"
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = [local.firehose_iam_role_arn]
    }
    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:DescribeKey"
    ]
    resources = ["*"]
  }

  statement {
    sid    = "Allow S3 service to use KMS key when SNS is encrypted"
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["s3.amazonaws.com"]
    }
    actions = [
      "kms:GenerateDataKey*",
      "kms:Decrypt"
    ]
    resources = ["*"]
  }

  statement {
    sid    = "Allow SNS service to use KMS key"
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["sns.amazonaws.com"]
    }
    actions = [
      "kms:GenerateDataKey*",
      "kms:Decrypt"
    ]
    resources = ["*"]
  }

  statement {
    sid    = "Allow Lacework to use KMS Key"
    effect = "Allow"
    principals {
      identifiers = ["arn:aws:iam::${var.lacework_aws_account_id}:role/lacework-platform"]
      type        = "AWS"
    }
    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:DescribeKey"
    ]
    resources = ["*"]
  }

  statement {
    sid    = "Allow principals in the account to decrypt with KMS key"
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
    actions = [
      "kms:Decrypt",
      "kms:ReEncryptFrom"
    ]
    resources = ["*"]
    condition {
      test     = "StringEquals"
      variable = "kms:CallerAccount"
      values   = [data.aws_caller_identity.current.account_id]
    }
  }
}

resource "random_id" "uniq" {
  byte_length = 4
}

resource "aws_sns_topic" "eks_sns_topic" {
  name              = local.sns_name
  kms_master_key_id = local.sns_topic_key_arn
  tags              = var.tags
}

resource "aws_sns_topic_policy" "eks_sns_topic_policy" {
  arn    = aws_sns_topic.eks_sns_topic.arn
  policy = data.aws_iam_policy_document.eks_sns_topic_policy.json
}

# we need the identity of the caller to get their account_id
data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "eks_sns_topic_policy" {

  statement {
    sid    = "AllowLaceworkToSubscribe"
    effect = "Allow"
    principals {
      identifiers = ["arn:aws:iam::${var.lacework_aws_account_id}:role/lacework-platform"]
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

#tfsec:ignore:aws-s3-enable-bucket-logging
resource "aws_s3_bucket" "eks_audit_log_bucket" {
  count         = var.use_existing_bucket ? 0 : 1
  bucket        = local.bucket_name
  force_destroy = var.bucket_force_destroy
  tags          = var.tags
}

resource "aws_s3_bucket_ownership_controls" "eks_audit_log_bucket_ownership_controls" {
  count  = var.use_existing_bucket ? 0 : 1
  bucket = aws_s3_bucket.eks_audit_log_bucket[0].id

  rule {
    object_ownership = "ObjectWriter"
  }
}

resource "aws_s3_bucket_public_access_block" "bucket_access" {
  count                   = var.use_existing_bucket ? 0 : 1
  bucket                  = aws_s3_bucket.eks_audit_log_bucket[0].id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_lifecycle_configuration" "eks_audit_log_bucket_lifecycle_config" {
  count  = var.use_existing_bucket ? 0 : 1
  bucket = aws_s3_bucket.eks_audit_log_bucket[0].id

  rule {
    id = "eks_audit_log_expiration"
    expiration {
      days = var.bucket_lifecycle_expiration_days
    }
    status = "Enabled"
  }
}

// v4 s3 bucket changes
resource "aws_s3_bucket_versioning" "export_versioning" {
  count  = var.use_existing_bucket ? 0 : 1
  bucket = aws_s3_bucket.eks_audit_log_bucket[0].id
  versioning_configuration {
    status     = local.bucket_versioning_enabled
    mfa_delete = local.mfa_delete
  }
}

resource "aws_s3_bucket_notification" "bucket_notification" {
  count  = var.use_existing_bucket ? 0 : 1
  bucket = aws_s3_bucket.eks_audit_log_bucket[0].id

  topic {
    topic_arn     = aws_sns_topic.eks_sns_topic.arn
    events        = ["s3:ObjectCreated:*"]
    filter_prefix = "eks_audit_logs/${data.aws_caller_identity.current.account_id}"
  }
  depends_on = [aws_sns_topic.eks_sns_topic, aws_sns_topic_policy.eks_sns_topic_policy]
}

resource "aws_s3_bucket_server_side_encryption_configuration" "bucket_encryption" {
  count  = var.bucket_encryption_enabled && !var.use_existing_bucket ? 1 : 0
  bucket = aws_s3_bucket.eks_audit_log_bucket[0].id
  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = local.bucket_key_arn
      sse_algorithm     = var.bucket_sse_algorithm
    }
  }
}

resource "aws_s3_bucket_logging" "eks_audit_log_bucket_logging" {
  count         = !var.bucket_logs_disabled && !var.use_existing_bucket ? 1 : 0
  bucket        = aws_s3_bucket.eks_audit_log_bucket[0].id
  target_bucket = var.use_existing_access_log_bucket ? local.log_bucket_name : aws_s3_bucket.log_bucket[0].id
  target_prefix = var.access_log_prefix
}

#tfsec:ignore:aws-s3-enable-bucket-logging
resource "aws_s3_bucket" "log_bucket" {
  count         = var.use_existing_access_log_bucket ? 0 : (var.bucket_logs_disabled ? 0 : 1)
  bucket        = local.log_bucket_name
  force_destroy = var.bucket_force_destroy
  tags          = var.tags
}

resource "aws_s3_bucket_ownership_controls" "log_bucket_ownership_controls" {
  count  = var.use_existing_access_log_bucket ? 0 : (var.bucket_logs_disabled ? 0 : 1)
  bucket = aws_s3_bucket.log_bucket[0].id

  rule {
    object_ownership = "ObjectWriter"
  }
}

resource "aws_s3_bucket_public_access_block" "log_bucket_access" {
  count                   = var.use_existing_access_log_bucket ? 0 : (var.bucket_logs_disabled ? 0 : 1)
  bucket                  = aws_s3_bucket.log_bucket[0].id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "log_bucket_versioning" {
  count  = var.use_existing_access_log_bucket ? 0 : (var.bucket_logs_disabled ? 0 : 1)
  bucket = aws_s3_bucket.log_bucket[0].id
  versioning_configuration {
    status     = local.bucket_versioning_enabled
    mfa_delete = local.mfa_delete
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "log_bucket_encryption" {
  count  = var.use_existing_access_log_bucket ? 0 : (var.bucket_logs_disabled ? 0 : local.bucket_encryption_enabled ? 1 : 0)
  bucket = aws_s3_bucket.log_bucket[0].id
  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = local.bucket_key_arn
      sse_algorithm     = var.bucket_sse_algorithm
    }
  }
}

resource "aws_iam_role" "firehose_iam_role" {
  count              = var.use_existing_firehose_iam_role ? 0 : 1
  name               = local.firehose_iam_role_name
  tags               = var.tags
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
  count       = var.use_existing_firehose_iam_role ? 0 : 1
  name        = local.firehose_policy_name
  description = "A firehose IAM policy"
  policy      = data.aws_iam_policy_document.firehose_iam_role_policy.json
}

resource "aws_iam_role_policy_attachment" "firehose_iam_role_policy" {
  count      = var.use_existing_firehose_iam_role ? 0 : 1
  role       = local.firehose_iam_role_name
  policy_arn = aws_iam_policy.firehose_iam_policy[0].arn
  depends_on = [aws_iam_policy.firehose_iam_policy[0]]
}

#tfsec:ignore:aws-iam-no-policy-wildcards
data "aws_iam_policy_document" "firehose_iam_role_policy" {
  version = "2012-10-17"

  statement {
    sid = "LaceworkEKSFirehoseIAMRole"
    actions = [
      "s3:PutObject",
    ]
    effect    = "Allow"
    resources = ["${local.bucket_arn}/eks_audit_logs/${data.aws_caller_identity.current.account_id}/*"]
  }
}

resource "aws_kinesis_firehose_delivery_stream" "extended_s3_stream" {
  name        = local.firehose_delivery_stream_name
  destination = "extended_s3"
  tags = var.tags

  extended_s3_configuration {
    role_arn            = local.firehose_iam_role_arn
    bucket_arn          = local.bucket_arn
    prefix              = "eks_audit_logs/${data.aws_caller_identity.current.account_id}/"
    buffering_interval  = 300
    buffering_size      = 100
    error_output_prefix = "audit_logs/${data.aws_caller_identity.current.account_id}/error/"
    compression_format  = "UNCOMPRESSED"
    cloudwatch_logging_options {
      enabled = false
    }
  }

  dynamic "server_side_encryption" {
    for_each = local.kinesis_firehose_encryption_enabled ? [1] : []
    content {
      enabled  = true
      key_type = "CUSTOMER_MANAGED_CMK"
      key_arn  = local.kinesis_firehose_key_arn
    }
  }

  depends_on = [aws_s3_bucket.eks_audit_log_bucket, aws_iam_role.firehose_iam_role]
}

module "lacework_eks_audit_iam_role" {
  count                   = var.use_existing_cross_account_iam_role ? 0 : 1
#  source                  = "lacework/iam-role/aws"
#  version                 = "~> 0.4"
  source                  = "git::https://github.com/lacework/terraform-aws-iam-role.git?ref=tmacdonald/grow-2447/use-external-IAM-role"
  create                  = true
  iam_role_name           = local.cross_account_iam_role_name
  lacework_aws_account_id = var.lacework_aws_account_id
  tags                    = var.tags
}

resource "aws_iam_policy" "eks_cross_account_policy" {
  count       = var.use_existing_cross_account_iam_role ? 0 : 1
  name        = local.cross_account_policy_name
  description = "A cross account policy to allow Lacework to write to pull eks audit logs"
  policy      = data.aws_iam_policy_document.eks_cross_account_policy.json
}

resource "aws_iam_role_policy_attachment" "eks_cross_account_role_policy" {
  count      = var.use_existing_cross_account_iam_role ? 0 : 1
  role       = local.cross_account_iam_role_name
  policy_arn = aws_iam_policy.eks_cross_account_policy[0].arn
  depends_on = [module.lacework_eks_audit_iam_role]
}

data "aws_iam_policy_document" "eks_cross_account_policy" {
  version = "2012-10-17"

  #tfsec:ignore:aws-iam-no-policy-wildcards
  statement {
    sid = "S3Permissions"
    actions = [
      "s3:GetObject",
    ]
    effect = "Allow"
    resources = [
      local.bucket_arn,
      "${local.bucket_arn}/*"
    ]
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
    sid       = "AccountAliasPermissions"
    actions   = ["iam:ListAccountAliases"]
    effect    = "Allow"
    resources = ["*"]
  }

  dynamic "statement" {
    for_each = var.allow_debugging_permissions ? [1] : []
    content {
      sid = "DebugPermissions"
      actions = [
        "eks:ListClusters",
        "logs:DescribeLogGroups",
        "logs:DescribeSubscriptionFilters",
        "firehose:ListDeliveryStreams",
        "firehose:DescribeDeliveryStream"
      ]
      effect    = "Allow"
      resources = ["*"]
    }
  }

  dynamic "statement" {
    for_each = var.allow_debugging_permissions ? [1] : []
    content {
      sid = "S3DebugPermissions"
      actions = [
        "s3:GetBucketAcl",
        "s3:GetBucketLocation",
        "s3:GetBucketNotificationConfiguration"
      ]
      effect    = "Allow"
      resources = [local.bucket_arn]
    }
  }
}

resource "aws_iam_role" "eks_cw_iam_role" {
  count              = var.use_existing_cloudwatch_iam_role ? 0 : 1
  name               = local.eks_cw_iam_role_name
  tags               = var.tags
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
  count       = var.use_existing_cloudwatch_iam_role ? 0 : 1
  name        = local.cw_iam_policy_name
  tags        = var.tags
  description = "EKS Cloudwatch IAM policy"
  policy      = data.aws_iam_policy_document.eks_cw_iam_role_policy.json
}

data "aws_iam_policy_document" "eks_cw_iam_role_policy" {
  version = "2012-10-17"

  statement {
    actions = [
      "firehose:PutRecord",
      "firehose:PutRecordBatch"
    ]
    effect    = "Allow"
    resources = ["arn:aws:firehose:*:${data.aws_caller_identity.current.account_id}:deliverystream/${local.firehose_delivery_stream_name}"]
  }
}

resource "aws_iam_role_policy_attachment" "eks_cw_iam_role_policy" {
  count      = var.use_existing_cloudwatch_iam_role ? 0 : 1
  role       = local.eks_cw_iam_role_name
  policy_arn = aws_iam_policy.eks_cw_iam_policy[0].arn
  depends_on = [aws_iam_role.eks_cw_iam_role, aws_iam_policy.eks_cw_iam_policy]
}

// for_each cluster, create a subscription filter
resource "aws_cloudwatch_log_subscription_filter" "lacework_eks_cw_subscription_filter" {
  for_each        = local.cluster_names
  name            = "${var.prefix}-${each.value}-eks-cw-${random_id.uniq.hex}"
  role_arn        = local.cloudwatch_iam_role_arn
  log_group_name  = "/aws/eks/${each.value}/cluster"
  filter_pattern  = var.filter_pattern
  destination_arn = aws_kinesis_firehose_delivery_stream.extended_s3_stream.arn
  depends_on      = [aws_iam_role.eks_cw_iam_role, aws_kinesis_firehose_delivery_stream.extended_s3_stream]
}

# set data resources for the iam roles either created or supplied for outputs
data "aws_arn" "iam_role" {
  arn = local.iam_role_arn
}

data "aws_arn" "firehose_iam_role" {
  arn = local.firehose_iam_role_arn
}

data "aws_arn" "cloudwatch_iam_role" {
  arn = local.cloudwatch_iam_role_arn
}

# wait for X seconds for things to settle down in the AWS side
# before trying to create the Lacework external integration
#
# https://github.com/hashicorp/terraform-provider-aws/issues/31139
resource "time_sleep" "wait_time_cw" {
  create_duration = var.wait_time
  depends_on = [
    aws_iam_role_policy_attachment.eks_cw_iam_role_policy
  ]
}

resource "lacework_integration_aws_eks_audit_log" "data_export" {
  name    = var.integration_name
  sns_arn = aws_sns_topic.eks_sns_topic.arn
  s3_bucket_arn = local.bucket_arn
  credentials {
    role_arn    = local.iam_role_arn
    external_id = local.iam_role_external_id
  }
  depends_on = [time_sleep.wait_time_cw]
}
