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

.PHONY: update-plugins
update-plugins:
	@cat vanilla/update-plugins.sh | ssh root@46.4.75.47

.PHONY: logs
logs:
	@ssh root@46.4.75.47 "docker compose logs --follow --no-log-prefix --since 24h vanilla | grep --invert-match --line-buffered 'Full render of map'"

.PHONY: build
build:
	@go build -o ./bin/deployerd ./cmd/deployerd/...

.PHONY: build-docker
build-docker:
	@docker compose build deployerd

.PHONY: run
run:
	@go run ./cmd/deployerd/...

.PHONY: run-docker
run-docker:
	@docker compose up deployerd
