.PHONY: init
init:
	@./scripts/with-env.sh terraform init

.PHONY: plan
plan:
	@mkdir -p plans
	@./scripts/with-env.sh terraform plan -input=false -out plans/$(shell date '+%d_%m_%Y_%H_%M_%S.tfplan')

.PHONY: apply
apply:
	@./scripts/with-env.sh terraform apply -input=false -auto-approve

.PHONY: lint
lint:
	@./scripts/with-env.sh tflint --init
	@./scripts/with-env.sh tflint --module --loglevel=info

.PHONY: connect
connect:
	@ssh root@46.4.75.47

.PHONY: install
install:
	@cat install.sh | ssh root@46.4.75.47
