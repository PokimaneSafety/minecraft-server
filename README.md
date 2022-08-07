# minecraft-server

## Setup

1. Install tfenv using the instructions [here](https://github.com/tfutils/tfenv).
2. Download terraform by running `tfenv install`.
3. Configure your environment: `cp .env.example .env && eval $EDITOR .env`.
4. If using VS Code, install the recommended extensions.
5. Bootstrap the project by executing `make init`.

## Linting

Terraform files can be linted using `tflint`, which you can install with [these instructions](https://github.com/terraform-linters/tflint).
Once installed, run `make lint`.

## Making Changes

You can preview your changes by executing a plan: `make plan`.
Generated plans will be output to the `./plans` directory.

If the plan looks good, you can apply the changes by executing `make apply`.
