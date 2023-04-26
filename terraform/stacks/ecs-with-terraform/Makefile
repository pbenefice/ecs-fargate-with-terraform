.PHONY: help tf-echo-backend tf-init-% tf-plan-% tf-apply-% tf-auto-approve-apply-% tf-destroy-%
default: help

help: ## Display this text.
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\t\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)
	@awk 'BEGIN {FS = "%:.*?## "} /^[a-zA-Z_-]+%:.*?## / {printf "\033[36m%-30s\t\033[0m %s\n", $$1"<env>", $$2}' $(MAKEFILE_LIST)

define message
  @echo "\033[0;32m$(1) \033[0m"
endef

tf-echo-backend: ## Display currently configured backend key
	$(eval BACKEND_KEY := $(shell cat .terraform/terraform.tfstate | jq -r '.backend.config.key'))
	$(call message,"Actually configured backend key : ${BACKEND_KEY}")

tf-init-%: ## terraform init for given env
	$(eval ENV := $(shell echo $@ | sed 's!^tf-init-\([a-zA-Z]*\)!\1!g'))
	sudo rm -rf .terraform/
	@terraform init -backend-config "config/${ENV}.s3.tfbackend"

tf-plan-%: | tf-echo-backend ## terraform plan for given env (require tf-init-%)
	$(eval ENV := $(shell echo $@ | sed 's!^tf-plan-\([a-zA-Z]*\)!\1!g'))
	$(eval FLAGGED_ENV := $(shell cat .terraform/terraform.tfstate | jq -r '.backend.config.key' | awk -F '-' '{print $$NF}'))
	@if [ "${FLAGGED_ENV}" != "${ENV}" ]; then echo "ERROR : Wrong env initiated, try running 'make tf-init-<env>' again" && exit 1; fi
	terraform plan -var-file "values/${ENV}.tfvars"

tf-apply-%: | tf-echo-backend ## terraform apply for given env (require tf-init-%)
	$(eval ENV := $(shell echo $@ | sed 's!^tf-apply-\([a-zA-Z]*\)!\1!g'))
	$(eval FLAGGED_ENV := $(shell cat .terraform/terraform.tfstate | jq -r '.backend.config.key' | awk -F '-' '{print $$NF}'))
	@if [ "${FLAGGED_ENV}" != "${ENV}" ]; then echo "ERROR : Wrong env initiated, try running 'make tf-init-<env>' again" && exit 1; fi
	terraform apply -var-file "values/${ENV}.tfvars"

tf-auto-approve-apply-%: | tf-echo-backend ## terraform apply for given env (require tf-init-%)
	$(eval ENV := $(shell echo $@ | sed 's!^tf-auto-approve-apply-\([a-zA-Z]*\)!\1!g'))
	$(eval FLAGGED_ENV := $(shell cat .terraform/terraform.tfstate | jq -r '.backend.config.key' | awk -F '-' '{print $$NF}'))
	@if [ "${FLAGGED_ENV}" != "${ENV}" ]; then echo "ERROR : Wrong env initiated, try running 'make tf-init-<env>' again" && exit 1; fi
	terraform apply -auto-approve -var-file "values/${ENV}.tfvars"

tf-destroy-%: | tf-echo-backend ## terraform destroy for given env (require tf-init-%)
	$(eval ENV := $(shell echo $@ | sed 's!^tf-destroy-\([a-zA-Z]*\)!\1!g'))
	$(eval FLAGGED_ENV := $(shell cat .terraform/terraform.tfstate | jq -r '.backend.config.key' | awk -F '-' '{print $$NF}'))
	@if [ "${FLAGGED_ENV}" != "${ENV}" ]; then echo "ERROR : Wrong env initiated, try running 'make tf-init-<env>' again" && exit 1; fi
	terraform destroy -var-file "values/${ENV}.tfvars"

ssm-bastion: ## Display the ssm command to connect to remote bastion ec2
	$(eval BASTION_ID := $(shell terraform output --json | jq -r '.bastion_id.value'))

	$(call message,"""To connect to bastion""")
	$(call message,"""  - Configure aws profile and run the following ssm command :""")
	@echo """aws ssm start-session --target ${BASTION_ID}"""
