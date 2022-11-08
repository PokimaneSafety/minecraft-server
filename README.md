# Minecraft Server

## Setup

1. Install tfenv using the instructions [here](https://github.com/tfutils/tfenv).
2. Download terraform by running `tfenv install`.
3. Configure your environment: `cp .env.example .env && open .env`.
4. If using VS Code, install the recommended extensions.
5. Bootstrap the project by executing `make init`.

## Linting

Terraform files can be linted using `tflint`, which you can install with [these instructions](https://github.com/terraform-linters/tflint).
Once installed, run `make lint`.

## Making Changes

You can preview your changes by creating a pull request which will execute a plan with credentials provisioned for the runner.

If the plan looks good, you can mark the pull request for review and it will be merged. The main branch has terraform applied automatically by the runner.
