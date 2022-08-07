init:
	./scripts/with-env.sh terraform init

plan:
	mkdir -p plans
	./scripts/with-env.sh terraform plan -input=false -out plans/$(shell date '+%d_%m_%Y_%H_%M_%S.tfplan')

apply:
	./scripts/with-env.sh terraform apply -input=false -auto-approve

lint:
	./scripts/with-env.sh tflint --init
	./scripts/with-env.sh tflint --module --loglevel=info
