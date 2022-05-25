<a href="https://lacework.com"><img src="https://techally-content.s3-us-west-1.amazonaws.com/public-content/lacework_logo_full.png" width="600"></a>

# terraform-aws-eks-audit-log

[![GitHub release](https://img.shields.io/github/release/lacework/terraform-aws-eks-audit-log.svg)](https://github.com/lacework/terraform-aws-eks-audit-log/releases/)
[![Codefresh build status]( https://g.codefresh.io/api/badges/pipeline/lacework/terraform-modules%2Ftest-compatibility?type=cf-1&key=eyJhbGciOiJIUzI1NiJ9.NWVmNTAxOGU4Y2FjOGQzYTkxYjg3ZDEx.RJ3DEzWmBXrJX7m38iExJ_ntGv4_Ip8VTa-an8gBwBo)]( https://g.codefresh.io/pipelines/edit/new/builds?id=607e25e6728f5a6fba30431b&pipeline=test-compatibility&projects=terraform-modules&projectId=607db54b728f5a5f8930405d)

A Terraform Module to integrate Amazon Elastic Kubernetes Service (EKS) with Lacework.

### Pre-requisite

Audit logging must be enabled on the cluster(s) which you wish to integrate. This can be done via the AWS CLI using the following command:

```bash
aws eks --region <region> update-cluster-config --name <cluster_name> \
--logging '{"clusterLogging":[{"types":["audit"],"enabled":true}]}'
```

## Resources created

- SNS topic
- Topic policy
- S3 bucket
- S3 bucket notification
- Firehose
- Firehose IAM role & policy
- Cross account IAM role & policy
- Cloudwatch IAM role & policy
- Cloudwatch subscription filter

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.15 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 4.0 |
| <a name="requirement_lacework"></a> [lacework](#requirement\_lacework) | ~> 0.17 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 2.1 |
| <a name="requirement_time"></a> [time](#requirement\_time) | ~> 0.6 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 4.0 |
| <a name="provider_lacework"></a> [lacework](#provider\_lacework) | ~> 0.17 |
| <a name="provider_random"></a> [random](#provider\_random) | >= 2.1 |
| <a name="provider_time"></a> [time](#provider\_time) | ~> 0.6 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_lacework_eks_audit_iam_role"></a> [lacework\_eks\_audit\_iam\_role](#module\_lacework\_eks\_audit\_iam\_role) | lacework/iam-role/aws | ~> 0.1 |

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_subscription_filter.lacework_eks_cw_subscription_filter](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_subscription_filter) | resource |
| [aws_iam_policy.eks_cross_account_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.eks_cw_iam_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.firehose_iam_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.eks_cw_iam_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.firehose_iam_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.eks_cross_account_role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.eks_cw_iam_role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.firehose_iam_role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_kinesis_firehose_delivery_stream.extended_s3_stream](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kinesis_firehose_delivery_stream) | resource |
| [aws_s3_bucket.eks_audit_log_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_lifecycle_configuration.eks_audit_log_bucket_lifecycle_config](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_lifecycle_configuration) | resource |
| [aws_s3_bucket_notification.bucket_notification](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_notification) | resource |
| [aws_s3_bucket_versioning.export_versioning](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_versioning) | resource |
| [aws_sns_topic.eks_sns_topic](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic) | resource |
| [aws_sns_topic_policy.eks_sns_topic_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic_policy) | resource |
| [lacework_integration_aws_eks_audit_log.data_export](https://registry.terraform.io/providers/lacework/lacework/latest/docs/resources/integration_aws_eks_audit_log) | resource |
| [random_id.uniq](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |
| [time_sleep.wait_time_cw](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/sleep) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.eks_cross_account_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.eks_cw_assume_role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.eks_cw_iam_role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.eks_sns_topic_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.firehose_iam_assume_role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.firehose_iam_role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_bucket_enable_mfa_delete"></a> [bucket\_enable\_mfa\_delete](#input\_bucket\_enable\_mfa\_delete) | Set this to `true` to require MFA for object deletion (Requires versioning) | `bool` | `false` | no |
| <a name="input_bucket_force_destroy"></a> [bucket\_force\_destroy](#input\_bucket\_force\_destroy) | Force destroy bucket (Required when bucket not empty) | `bool` | `false` | no |
| <a name="input_bucket_lifecycle_expiration_days"></a> [bucket\_lifecycle\_expiration\_days](#input\_bucket\_lifecycle\_expiration\_days) | The lifetime, in days, of the bucket objects. The value must be a non-zero positive integer. | `number` | `180` | no |
| <a name="input_bucket_versioning_enabled"></a> [bucket\_versioning\_enabled](#input\_bucket\_versioning\_enabled) | Set this to `true` to enable access versioning on a created S3 bucket | `bool` | `true` | no |
| <a name="input_cloudwatch_regions"></a> [cloudwatch\_regions](#input\_cloudwatch\_regions) | A set of regions, to allow Cloudwatch Logs to be streamed from | `list(string)` | n/a | yes |
| <a name="input_cluster_names"></a> [cluster\_names](#input\_cluster\_names) | A set of cluster names, to integrate with. Defaults to [] if `no_cw_subscription_filter` is set to `true` | `set(string)` | `[]` | no |
| <a name="input_external_id_length"></a> [external\_id\_length](#input\_external\_id\_length) | The length of the external ID to generate. Max length is 1224. Ignored when `use_existing_iam_role` is set to `true` | `number` | `16` | no |
| <a name="input_filter_pattern"></a> [filter\_pattern](#input\_filter\_pattern) | The Cloudwatch Log Subscription Filter pattern | `string` | `"{ $.stage = \"ResponseComplete\" && $.requestURI != \"/version\" && $.requestURI != \"/version?*\" && $.requestURI != \"/metrics\" && $.requestURI != \"/metrics?*\" && $.requestURI != \"/logs\" && $.requestURI != \"/logs?*\" && $.requestURI != \"/swagger*\" && $.requestURI != \"/livez*\" && $.requestURI != \"/readyz*\" && $.requestURI != \"/healthz*\" }"` | no |
| <a name="input_integration_name"></a> [integration\_name](#input\_integration\_name) | The name of the AWS EKS Audit Log integration in Lacework. | `string` | `"TF AWS EKS Audit Log"` | no |
| <a name="input_lacework_aws_account_id"></a> [lacework\_aws\_account\_id](#input\_lacework\_aws\_account\_id) | The Lacework AWS account that the IAM role will grant access | `string` | `"434813966438"` | no |
| <a name="input_no_cw_subscription_filter"></a> [no\_cw\_subscription\_filter](#input\_no\_cw\_subscription\_filter) | Set to true to create an integration with no Cloudwatch Subscription filter for your cluster(s) | `bool` | `false` | no |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | The prefix that will be use at the beginning of every generated resource | `string` | `"lw-eks-al"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map/dictionary of Tags to be assigned to created resources | `map(string)` | `{}` | no |
| <a name="input_wait_time"></a> [wait\_time](#input\_wait\_time) | Amount of time between setting up AWS resources, and creating the Lacework integration. | `string` | `"10s"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_bucket_arn"></a> [bucket\_arn](#output\_bucket\_arn) | Lacework AWS EKS Audit Log S3 Bucket ARN |
| <a name="output_bucket_name"></a> [bucket\_name](#output\_bucket\_name) | Lacework AWS EKS Audit Log S3 Bucket name |
| <a name="output_cloudwatch_iam_role_arn"></a> [cloudwatch\_iam\_role\_arn](#output\_cloudwatch\_iam\_role\_arn) | The Cloudwatch IAM Role ARN |
| <a name="output_cloudwatch_iam_role_name"></a> [cloudwatch\_iam\_role\_name](#output\_cloudwatch\_iam\_role\_name) | The Cloudwatch IAM Role name |
| <a name="output_cross_account_iam_role_arn"></a> [cross\_account\_iam\_role\_arn](#output\_cross\_account\_iam\_role\_arn) | The Cross Account IAM Role ARN |
| <a name="output_cross_account_iam_role_name"></a> [cross\_account\_iam\_role\_name](#output\_cross\_account\_iam\_role\_name) | The Cross Account IAM Role name |
| <a name="output_external_id"></a> [external\_id](#output\_external\_id) | The External ID configured into the IAM role |
| <a name="output_filter_pattern"></a> [filter\_pattern](#output\_filter\_pattern) | The Cloudwatch Log Subscription Filter pattern |
| <a name="output_filter_prefix"></a> [filter\_prefix](#output\_filter\_prefix) | The Cloudwatch Log Subscription filter prefix |
| <a name="output_firehose_arn"></a> [firehose\_arn](#output\_firehose\_arn) | The Firehose IAM Role ARN |
| <a name="output_firehose_iam_role_name"></a> [firehose\_iam\_role\_name](#output\_firehose\_iam\_role\_name) | The Firehose IAM Role name |
| <a name="output_sns_arn"></a> [sns\_arn](#output\_sns\_arn) | SNS Topic ARN |
| <a name="output_sns_name"></a> [sns\_name](#output\_sns\_name) | SNS Topic name |
