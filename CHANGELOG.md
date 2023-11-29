# v1.1.1

## Refactor
* refactor(role): update to use Lacework external IAM role (#53) (Timothy MacDonald)([9d8c17f](https://github.com/lacework/terraform-aws-eks-audit-log/commit/9d8c17f73a775e53c5e407eb64484163541eb864))
## Bug Fixes
* fix: make S3 MFA delete disabling bucket lifecycle (#54) (Denys Havrysh)([75f2670](https://github.com/lacework/terraform-aws-eks-audit-log/commit/75f26702f1d1723e7b61c3bf0409f6baba7990e1))
## Documentation Updates
* docs(readme): add terraform docs automation (#52) (Timothy MacDonald)([135e736](https://github.com/lacework/terraform-aws-eks-audit-log/commit/135e736dfcf816f9ac24b5f1bf5e61a714ecd7fa))
## Other Changes
* ci: version bump to v1.1.1-dev (Lacework)([abb899d](https://github.com/lacework/terraform-aws-eks-audit-log/commit/abb899d5bc6be0ecb4797fa5ada8027251d1d332))
---
# v1.1.0

## Features
* feat: enforce External ID v2 format via iam-role module (#50) (djmctavish)([2fcf441](https://github.com/lacework/terraform-aws-eks-audit-log/commit/2fcf441d17f4e71e082420b3a7cb8fd3b0934efb))
## Bug Fixes
* fix: set AWS tags on missing resources (#48) (bartek-1337-lw)([fc3a0a7](https://github.com/lacework/terraform-aws-eks-audit-log/commit/fc3a0a759b02ce50c9d8c5848bc6e3cc23bd137d))
* fix: Add S3 bucket arn to integration (#49) (djmctavish)([9b26167](https://github.com/lacework/terraform-aws-eks-audit-log/commit/9b261672f2afc05fb7e2a6e79a73b1799ce68a8c))
## Other Changes
* ci: version bump to v1.0.4-dev (Lacework)([b79f07c](https://github.com/lacework/terraform-aws-eks-audit-log/commit/b79f07cec4a25b438b17b544be3bde1dc1c6648f))
---
# v1.0.3

## Bug Fixes
* fix: Limit IAM permissions for EKS (#46) (Bhuvan Basireddy)([03cdc3d](https://github.com/lacework/terraform-aws-eks-audit-log/commit/03cdc3d9e6cc5ea009f14650378c3f3acd8fce94))
## Other Changes
* ci: version bump to v1.0.3-dev (Lacework)([38234f9](https://github.com/lacework/terraform-aws-eks-audit-log/commit/38234f96d8ee36a7ead4997888c2f336cc688006))
---
# v1.0.2

## Refactor
* refactor(IAM): Limit permissions for firehose and cross account policies (#43) (Bhuvan Basireddy)([b1a39db](https://github.com/lacework/terraform-aws-eks-audit-log/commit/b1a39dbd27e81ab3b398b2433231916eb518e30b))
## Other Changes
* chore: enable bucket_force_destroy by default (#44) (Salim Afiune)([318e9dd](https://github.com/lacework/terraform-aws-eks-audit-log/commit/318e9ddc9fe410cd05194c463b929459310b2902))
* ci: version bump to v1.0.2-dev (Lacework)([bfde032](https://github.com/lacework/terraform-aws-eks-audit-log/commit/bfde0323a62efc20fea1e297bf7473ed27e1d789))
---
# v1.0.1

## Bug Fixes
* fix: avoid S3 bucket race condition (#41) (jonathan stewart)([eb2492f](https://github.com/lacework/terraform-aws-eks-audit-log/commit/eb2492f0bbf6a60ae5ec1adde194c599faee3c5a))
## Other Changes
* ci: version bump to v1.0.1-dev (Lacework)([bf055ed](https://github.com/lacework/terraform-aws-eks-audit-log/commit/bf055ed7f42fcae9375d04361dae58f8e24cfa52))
---
# v1.0.0

## Features
* feat: Add support for AWS provider 5.0 (#39) (Darren)([d930cc7](https://github.com/lacework/terraform-aws-eks-audit-log/commit/d930cc709e0d4519a6f860763967494221fff26e))
## Other Changes
* ci: version bump to v0.5.3-dev (Lacework)([040962d](https://github.com/lacework/terraform-aws-eks-audit-log/commit/040962d4d39ed60c01760bded0f5eabe88d28ce3))
---
# v0.5.2

## Bug Fixes
* fix: Least privilege for Firehose (#37) (Bhuvan Basireddy)([0ff6334](https://github.com/lacework/terraform-aws-eks-audit-log/commit/0ff6334b4127359e9b6cf19b378be27077d9d7d2))
## Other Changes
* ci: version bump to v0.5.2-dev (Lacework)([ea26c4b](https://github.com/lacework/terraform-aws-eks-audit-log/commit/ea26c4bcc4418b153a62fd9cc273fb19ae441f9d))
---
# v0.5.1

## Bug Fixes
* fix: Update S3 bucket naming convention (#34) (djmctavish)([64e2d03](https://github.com/lacework/terraform-aws-eks-audit-log/commit/64e2d0369a17e441d9e7600cf0ad3cf58145e192))
## Other Changes
* ci: version bump to v0.5.1-dev (Lacework)([4bc38b1](https://github.com/lacework/terraform-aws-eks-audit-log/commit/4bc38b1b4412a2400ed3304ab1eb8974093e2648))
---
# v0.5.0

## Features
* feat: Allow user defined S3 Bucket for the audit log (#31) (djmctavish)([6f8962d](https://github.com/lacework/terraform-aws-eks-audit-log/commit/6f8962d88bfa2911bd20728389ae8818969902ec))
## Other Changes
* ci: version bump to v0.4.5-dev (Lacework)([b0c93f3](https://github.com/lacework/terraform-aws-eks-audit-log/commit/b0c93f394fe0410006e6e0476a495916637045cc))
---
# v0.4.4

## Bug Fixes
* fix: s3 bucket ownership controls (#29) (jonathan stewart)([3511ad6](https://github.com/lacework/terraform-aws-eks-audit-log/commit/3511ad693a5aeee76f9b56f17ae8f486517e6875))
## Other Changes
* ci: version bump to v0.4.4-dev (Lacework)([a7bb115](https://github.com/lacework/terraform-aws-eks-audit-log/commit/a7bb115fdc217aaf7f5c95addd35833c4dd37ed3))
---
# v0.4.3

## Bug Fixes
* fix: update readme (#27) (jonathan stewart)([86ee504](https://github.com/lacework/terraform-aws-eks-audit-log/commit/86ee5045ff872b3f1b3ba38283143b638303ac13))
* fix: logging bucket (#26) (jonathan stewart)([183c395](https://github.com/lacework/terraform-aws-eks-audit-log/commit/183c395d21589209cce33448b907e5f5665f334a))
* fix: tfsec fix (#25) (jonathan stewart)([1b7f5f6](https://github.com/lacework/terraform-aws-eks-audit-log/commit/1b7f5f62adc870e9b869c93a1f4cdf75b70379af))
* fix: ci tfsec scan (#24) (jonathan stewart)([4e4b7f2](https://github.com/lacework/terraform-aws-eks-audit-log/commit/4e4b7f2998518282bc29ce45a5708120bae69db7))
## Documentation Updates
* docs: example of custom filter added (David McTavish)([191a2c0](https://github.com/lacework/terraform-aws-eks-audit-log/commit/191a2c0b468e264f7b8b3c31ebfee649b8f13487))
## Other Changes
* chore: Update ci_tests for new custom filter example (David McTavish)([bafd52d](https://github.com/lacework/terraform-aws-eks-audit-log/commit/bafd52d79ddd1e35750968cbcc59ae7f26b92267))
* ci: version bump to v0.4.3-dev (Lacework)([00a0660](https://github.com/lacework/terraform-aws-eks-audit-log/commit/00a0660a1ffcaa946b315142e71ecc2ddbe8c513))
---
# v0.4.2

## Documentation Updates
* docs: update Lacework provider version in readme (#20) (Darren)([ba72a3a](https://github.com/lacework/terraform-aws-eks-audit-log/commit/ba72a3a57027654b2331cf598bb1101500c708ab))
## Other Changes
* chore: update Lacework provider version to v1 (#19) (Darren)([add0d49](https://github.com/lacework/terraform-aws-eks-audit-log/commit/add0d49a5ff6c46531a3762d685bf7c89a7f557b))
* ci: version bump to v0.4.2-dev (Lacework)([6c30e55](https://github.com/lacework/terraform-aws-eks-audit-log/commit/6c30e5533220eaa350109f61b8d4bc71bb253359))
---
# v0.4.1

## Bug Fixes
* fix: Re-add firehose_arn output (#17) (Ross)([3d4af5d](https://github.com/lacework/terraform-aws-eks-audit-log/commit/3d4af5d03b0039b2c1f056d7b7f7efa423a40bdd))
## Other Changes
* ci: version bump to v0.4.1-dev (Lacework)([4fdd82c](https://github.com/lacework/terraform-aws-eks-audit-log/commit/4fdd82cdefd825495b81635f47bbdee0b499b8cf))
---
# v0.4.0

## Features
* feat: add support to use existing IAM roles.  Fix encryption logic. (#13) (Steve)([9a4f892](https://github.com/lacework/terraform-aws-eks-audit-log/commit/9a4f892d6ed8fdda3c5357f32a2e38f21307949e))
## Other Changes
* ci: version bump to v0.3.1-dev (Lacework)([1669a21](https://github.com/lacework/terraform-aws-eks-audit-log/commit/1669a2180d863af47abf4bc7da1c6c605cdcdd2a))
* test: update examples with new output name (#15) (Darren)([dc48ab1](https://github.com/lacework/terraform-aws-eks-audit-log/commit/dc48ab1787a58d766224bb7c9b6ab1a9d1e35445))
---
# v0.3.0

## Features
* feat: Add encryption support for Kinesis Firehose, S3 Bucket, and SNS topic (#6) (Steve)([ddc78cb](https://github.com/lacework/terraform-aws-eks-audit-log/commit/ddc78cbfb4fa21b6e80d764adbeb27de65e41f77))
## Documentation Updates
* docs: update docs using 'terraform-docs' cmd (#5) (Darren)([ba5d1aa](https://github.com/lacework/terraform-aws-eks-audit-log/commit/ba5d1aafe05a83215251608277ad0b202dfc5ac7))
## Other Changes
* chore: Update the EKS Audit README using terraform-docs (#9) (Ross)([f2771a4](https://github.com/lacework/terraform-aws-eks-audit-log/commit/f2771a4e6198d6b9b9a9bd9dfc8fc28462c4ffea))
* chore: Add multi_region tests to ci script (Ross)([5222131](https://github.com/lacework/terraform-aws-eks-audit-log/commit/5222131ba6ebc92ef5194487217dff3d734e92ea))
* ci: add new examples to ci_tests.sh (#7) (Salim Afiune)([297a2e9](https://github.com/lacework/terraform-aws-eks-audit-log/commit/297a2e9a2493fc9a858010361a021b96a72b2be2))
* ci: version bump to v0.2.1-dev (Lacework)([bdeada7](https://github.com/lacework/terraform-aws-eks-audit-log/commit/bdeada79f25272ffe910cdc86aedc79f3b6265e4))
---
# v0.2.0

## Features
* feat: update examples README version pin (Ross)([3f5fe33](https://github.com/lacework/terraform-aws-eks-audit-log/commit/3f5fe33b2781886b63c3380dc91c024f5fd467af))
* feat: Address review comments (Ross)([6981915](https://github.com/lacework/terraform-aws-eks-audit-log/commit/69819154d946336bab1c7611b36568360a6d3faa))
* feat: Add filter_pattern as variable (Ross)([bac1c5a](https://github.com/lacework/terraform-aws-eks-audit-log/commit/bac1c5a0f00e269115a143634e356988c4534dfd))
* feat: Address review comments (Ross)([e0c0b7f](https://github.com/lacework/terraform-aws-eks-audit-log/commit/e0c0b7f5f96e8278e972aaf2bceb0f075ed68ca1))
* feat: Update Examples README docs link (Ross)([cb0470c](https://github.com/lacework/terraform-aws-eks-audit-log/commit/cb0470c7f07e53c528b102d1f315f0b564e6252d))
* feat: update default example README (Ross)([5d2cb88](https://github.com/lacework/terraform-aws-eks-audit-log/commit/5d2cb88ea6e47aabd02c464443a5cdf3670d5113))
* feat: refactor main.tf and update examples, outputs & variables (Ross)([ec7d47f](https://github.com/lacework/terraform-aws-eks-audit-log/commit/ec7d47fbd75f19b9f56043c712e77af8e0df601c))
* feat: Address review comments (Ross)([498b160](https://github.com/lacework/terraform-aws-eks-audit-log/commit/498b160c7e84494e8ce1221e7b9fc64e9711a5d3))
* feat: Add bucket lifecycle rule (Ross)([a941f5e](https://github.com/lacework/terraform-aws-eks-audit-log/commit/a941f5ed06a2aafa33a665075701a28beb0f3d65))
* feat: Address review comment (Ross)([84d11c5](https://github.com/lacework/terraform-aws-eks-audit-log/commit/84d11c5dc3a8600b340db76454f5dc65f71426e7))
* feat: Update README (Ross)([47025fb](https://github.com/lacework/terraform-aws-eks-audit-log/commit/47025fb5234dc65330b01b9f244e22d5bc7c09ee))
* feat: Initial add of AWS EKS Audit Log module (Ross)([638305c](https://github.com/lacework/terraform-aws-eks-audit-log/commit/638305c717779881fb9f7909f395a1550aa619b2))
## Other Changes
* chore(rename): Rename to terraform-aws-eks-audit-log (Ross)([1b6ca89](https://github.com/lacework/terraform-aws-eks-audit-log/commit/1b6ca89146da74d2a404a4e65ca07fcfa7d6e888))
* chore(setup): Add config and docs (Ross)([4afdec5](https://github.com/lacework/terraform-aws-eks-audit-log/commit/4afdec566c30817798daaac597e00e30ba52202c))
* chore(setup): Initial setup of terraform-aws-eks repo (Ross)([5851211](https://github.com/lacework/terraform-aws-eks-audit-log/commit/5851211f12450e0f17851ec7148ec6c6599706c0))
* chore: bump required version of TF to 0.12.31 (#3) (Scott Ford)([bf6cdf6](https://github.com/lacework/terraform-aws-eks-audit-log/commit/bf6cdf68a271cc49560dd66bb60fd590b0b1328c))
* ci: sign lacework-releng commits (#4) (Salim Afiune)([7a5d2bd](https://github.com/lacework/terraform-aws-eks-audit-log/commit/7a5d2bd2b5468d6d6e1537bcbdfa0cbbefded641))
* ci: fix finding major versions during release (#2) (Salim Afiune)([72197f2](https://github.com/lacework/terraform-aws-eks-audit-log/commit/72197f2f20bf5d67710a2bc2d38d4844427e6d77))
---
