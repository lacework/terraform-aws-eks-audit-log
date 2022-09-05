variable "bucket_enable_mfa_delete" {
  type        = bool
  default     = false
  description = "Set this to `true` to require MFA for object deletion (Requires versioning)"
}

variable "bucket_versioning_enabled" {
  type        = bool
  default     = true
  description = "Set this to `true` to enable access versioning on a created S3 bucket"
}

variable "bucket_lifecycle_expiration_days" {
  type        = number
  default     = 180
  description = "The lifetime, in days, of the bucket objects. The value must be a non-zero positive integer."
}

variable "bucket_force_destroy" {
  type        = bool
  default     = false
  description = "Force destroy bucket (Required when bucket not empty)"
}

variable "cloudwatch_regions" {
  type        = list(string)
  description = "A set of regions, to allow Cloudwatch Logs to be streamed from"
}

variable "cluster_names" {
  type        = set(string)
  description = "A set of cluster names, to integrate with. Defaults to [] if `no_cw_subscription_filter` is set to `true`"
  default     = []
}

variable "external_id_length" {
  type        = number
  default     = 16
  description = "The length of the external ID to generate. Max length is 1224."
}

variable "filter_pattern" {
  type        = string
  default     = "{ $.stage = \"ResponseComplete\" && $.requestURI != \"/version\" && $.requestURI != \"/version?*\" && $.requestURI != \"/metrics\" && $.requestURI != \"/metrics?*\" && $.requestURI != \"/logs\" && $.requestURI != \"/logs?*\" && $.requestURI != \"/swagger*\" && $.requestURI != \"/livez*\" && $.requestURI != \"/readyz*\" && $.requestURI != \"/healthz*\" }"
  description = "The Cloudwatch Log Subscription Filter pattern"
}

variable "integration_name" {
  type        = string
  default     = "TF AWS EKS Audit Log"
  description = "The name of the AWS EKS Audit Log integration in Lacework."
}

variable "lacework_aws_account_id" {
  type        = string
  default     = "434813966438"
  description = "The Lacework AWS account that the IAM role will grant access"
}

variable "no_cw_subscription_filter" {
  type        = bool
  default     = false
  description = "Set to true to create an integration with no Cloudwatch Subscription filter for your cluster(s)"
}

variable "prefix" {
  type        = string
  default     = "lw-eks-al"
  description = "The prefix that will be use at the beginning of every generated resource"
}

variable "tags" {
  type        = map(string)
  description = "A map/dictionary of Tags to be assigned to created resources"
  default     = {}
}

variable "wait_time" {
  type        = string
  default     = "10s"
  description = "Amount of time between setting up AWS resources, and creating the Lacework integration."
}

variable "bucket_encryption_enabled" {
  type        = bool
  default     = true
  description = "Set this to `true` to enable encryption on a created S3 bucket"
}

variable "bucket_sse_algorithm" {
  type        = string
  default     = "aws:kms"
  description = "The encryption algorithm to use for S3 bucket server-side encryption"
}

variable "bucket_key_arn" {
  type        = string
  default     = ""
  description = "The ARN of the KMS encryption key to be used for S3 (Required when `bucket_sse_algorithm` is `aws:kms` and using an existing aws_kms_key)"
}

variable "kms_key_rotation" {
  type        = bool
  default     = true
  description = "Enable KMS automatic key rotation"
}

variable "kms_key_deletion_days" {
  type        = number
  default     = 30
  description = "The waiting period, specified in number of days"
}

variable "kms_key_multi_region" {
  type        = bool
  default     = true
  description = "Whether the KMS key is a multi-region or regional key"
}

variable "kinesis_firehose_encryption_enabled" {
  type        = bool
  default     = true
  description = "Set this to `false` to disable encryption on the Kinesis Firehose. Defaults to true"
}

variable "kinesis_firehose_key_arn" {
  type        = string
  default     = ""
  description = "The ARN of an existing KMS encryption key to be used for the Kinesis Firehose"
}

variable "sns_topic_encryption_enabled" {
  type        = bool
  default     = true
  description = "Set this to `false` to disable encryption on the sns topic. Defaults to true"
}

variable "sns_topic_key_arn" {
  type        = string
  default     = ""
  description = "The ARN of an existing KMS encryption key to be used for the SNS topic"
}

variable "use_existing_cross_account_iam_role" {
  type        = bool
  default     = false
  description = "Set this to true to use an existing IAM role for cross-account access"
}

variable "iam_role_arn" {
  type        = string
  default     = ""
  description = "IAM role arn to use for cross-account access if use_existing_cross_account_iam_role is set to true"
}

variable "iam_role_external_id" {
  type        = string
  default     = ""
  description = "External ID for the cross-account IAM role if use_existing_cross_account_iam_role is set to true"
}

variable "use_existing_cloudwatch_iam_role" {
  type        = bool
  default     = false
  description = "Set this to true to use an existing IAM role for the Cloudwatch subscription filter"
}

variable "cloudwatch_iam_role_arn" {
  type        = string
  default     = ""
  description = "IAM role arn to use for the Cloudwatch filter if use_existing_cloudwatch_iam_role is set to true"
}

variable "use_existing_firehose_iam_role" {
  type        = bool
  default     = false
  description = "Set this to true to use an existing IAM role for the Kinesis Firehose"
}

variable "firehose_iam_role_arn" {
  type        = string
  default     = ""
  description = "IAM role arn to use for the Kinesis Firehose if use_existing_firehose_iam_role is set to true"
}
