aws_region = "eu-west-1"
aws_profile = "tunnel49"
tfstate_bucket = "tfstate.tunnel49.net"
tfstate_key = "tunnel49/voucherfactory"

terraform_dir = "terraform"
build_dir = "build"
source_dir = "source"

tf_plan = $(build_dir)/tf_plan

tf_cmd = AWS_PROFILE=$(aws_profile) terraform -chdir=$(terraform_dir) 

package: $(source_dir)/*.py |init
$(source_dir)/*.py: |init
	@echo packaging sources
	@for f in $^; do echo "packaging $${f##*/}..."; zip -q $(build_dir)/$${f##*/}.zip $${f}; done
	@echo packaging complete
init:
	@mkdir -p $(build_dir) $(terraform_dir) $(source_dir)
awsinit:
	@echo we should test aws connectivity and bucket here
clean: |init
	@rm -rf $(build_dir)/*
tfreset: |init awsinit
	@$(tf_cmd) init -reconfigure \
		-backend-config "bucket=$(tfstate_bucket)" \
		-backend-config "key=$(tfstate_key)" \
		-backend-config "region=$(aws_region)"
plan: |init awsinit 
	@$(tf_cmd) plan -out ../$(tf_plan) \
	-var region=$(aws_region) \
	-var tf_state_bucket=$(tfstate_bucket) \
	-var tf_state_key=$(tfstate_key)
apply: |init awsinit 
	@$(tf_cmd) apply ../$(tf_plan)
build: |package plan
all: |package plan apply
