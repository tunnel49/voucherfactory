aws_region = "eu-west-1"
aws_profile = "tunnel49"
tfstate_bucket = "tfstate.tunnel49.net"
tfstate_key = "tunnel49/voucherfactory"

terraform_dir = terraform
build_dir = build
source_dir = source

tf_plan = $(build_dir)/tf_plan
tf_parameters = -var region=$(aws_region) -var tf_state_bucket=$(tfstate_bucket) -var tf_state_key=$(tfstate_key)

tf_cmd = AWS_PROFILE=$(aws_profile) terraform -chdir=$(terraform_dir) 

SRC_FILES := $(wildcard $(source_dir)/*.py)
ZIP_FILES := $(patsubst $(source_dir)/%.py,%.zip,$(SRC_FILES))

package: $(ZIP_FILES) |init
	@echo packaging complete
%.zip: $(source_dir)/%.py
	@echo packaging $@; \
	cd $(source_dir); \
	zip -FSq ../$(build_dir)/$@ $(notdir $<)
	
init:
	@mkdir -p $(build_dir) $(terraform_dir) $(source_dir)
awsinit:
	#TODO: we should test aws connectivity and bucket here
clean: |init
	@rm -rf $(build_dir)/*
tfreset: |init awsinit
	@$(tf_cmd) init -reconfigure \
		-backend-config "bucket=$(tfstate_bucket)" \
		-backend-config "key=$(tfstate_key)" \
		-backend-config "region=$(aws_region)"
plan: |init awsinit 
	@$(tf_cmd) plan -out ../$(tf_plan) $(tf_parameters)
$(tf_plan):
apply: $(tf_plan) |init awsinit 
	@$(tf_cmd) apply ../$<
build: |package plan
all: |package plan apply
destroy: |init awsinit
	@$(tf_cmd) destroy $(tf_parameters)
