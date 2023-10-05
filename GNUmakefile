default: ci

ci:
	scripts/ci_tests.sh

release: ci
	scripts/release.sh prepare

.PHONY: terraform-docs
terraform-docs:
	scripts/terraform-docs.sh

