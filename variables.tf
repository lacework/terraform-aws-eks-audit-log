variable "bucket_enable_mfa_delete" {
  type        = bool
  default     = false
  description = "Set this to `true` to require MFA for object deletion (Requires versioning)"
}

variable "bucket_enable_versioning" {
  type        = bool
  default     = false
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

variable "cloudwatch_region" {
  type        = string
  description = "The region, to stream CloudWatch logs from"
  default     = "eu-west-1"
}

variable "cluster_names" {
  type        = list(string)
  description = "A list of cluster names, to integrate with"
  default     = ["cluster-aic7NmW6"]
}

variable "external_id_length" {
  type        = number
  default     = 16
  description = "The length of the external ID to generate. Max length is 1224. Ignored when `use_existing_iam_role` is set to `true`"
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
