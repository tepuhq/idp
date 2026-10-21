# Stage 1: Local toolchain and endpoint safety

## Environment

- Date: 10/21/2026
- OS: Windows 11
- Floci version: v2.3.0
- AWS CLI version: v2.38.4
- Terraform version: v1.16.6
- Docker version: v29.5.3

## Setup

- Started the Floci container

```shell
docker compose -f .\local\docker-compose.yaml up -d
```

- Configured the AWS CLI with dummy credentials and the Floci endpoint. Dot-sourcing keeps the variables for the whole shell session

```shell
. .\env.ps1
```

## Exercises

### 1. CLI request to Floci

- Commands: `aws s3 mb s3://my-bucket`, `aws s3 ls`
- Result: `aws s3 mb` created the bucket and `aws s3 ls` listed it. Note that `mb` changes state; only `aws s3 ls` is read-only

```shell
PS C:\Users\jpgom\Documents\github\idp\infra> aws s3 mb s3://my-bucket
make_bucket: my-bucket
PS C:\Users\jpgom\Documents\github\idp\infra> aws s3 ls
2026-10-21 19:25:52 my-bucket
```

### 2. Terraform init

- Commands: `terraform init`, `terraform validate`
- Result: `terraform init` installed the `hashicorp/aws` provider v6.69.1 and initialized the working directory (local backend). `terraform validate` reported no errors in the configuration

## Endpoint safety

- Three things keep local commands away from real AWS:
  - Dummy credentials (`test`/`test`), which real AWS rejects
  - The endpoint, set through `AWS_ENDPOINT_URL` for the CLI and `var.endpoint` for Terraform
  - The Terraform `endpoints` block, which routes each listed service to Floci
- If a service is missing from the `endpoints` block, Terraform sends that call to real AWS. With no real credentials configured, the call fails with an auth error instead of creating anything or costing money
- No real AWS credentials exist on this machine

## Problems and notes

- `*.tfvars` is in `.gitignore`, which also ignored `example.tfvars`. Fixed by renaming it to `terraform.tfvars.example`, which the `*.tfvars` pattern does not match
- `variable "endpoint"` was declared but `provider.tf` still had the hardcoded URL, so the variable did nothing until the provider used `var.endpoint`

## Cleanup

- Ran `terraform destroy` to remove the resources Terraform created
- `terraform destroy` only removes resources in the state. `my-bucket` was created with the CLI, so it has to be removed separately

```shell
aws s3 rb s3://my-bucket
aws s3 ls
```

- Stop Floci when finished

```shell
docker compose -f .\local\docker-compose.yaml down
```

## Tips

- Run `. .\env.ps1` in every new terminal. The variables only live in that session, so a new terminal has no endpoint
- Before creating anything, run a read-only command (`aws s3 ls`) to confirm the endpoint works. `aws configure list` shows which credentials the CLI is using
- Use `docker ps` to check that the Floci container is running before blaming the CLI or Terraform
- Run `terraform validate` and `terraform plan` before `terraform apply`. `terraform plan -destroy` previews a destroy
- Anything created outside Terraform (CLI, console) is not in the state, so Terraform will not manage or delete it
- Do not commit `terraform.tfstate` or `.terraform/`
- Keep a `terraform.tfvars.example` with safe values so the setup can be repeated on a fresh clone
