# Google Cloud Platform - Terraform VPC Module ![Terraform](https://github.com/lzysh/terraform-google-vpc/workflows/Terraform/badge.svg)

Terraform module for a Google Cloud Platform VPC.

## Usage

```hcl
module "shared-vpc" {
  source = "git@github.com:lzysh/terraform-google-vpc.git?ref=v1.1.0"
  
  project_id = module.project.project_id

  subnets = [
    {
      subnet_name      = "lzysh-vpc-us-east4"
      subnet_range     = var.cidr_range
      subnet_region    = "us-east4"
      subnet_flow_logs = "true"
    },
  ]

  secondary_ranges = var.secondary_ranges
}
```

## Module Testing

Create local.tfvars from local.tfvars.EXAMPLE and populate the required variables, then run the following commands:

`terraform init` to initialize a working directory containing Terraform configuration files

`terraform validate` to validate the configuration files in a directory

`terraform plan -out="plan.out" -var-file="local.tfvars"` to create an execution plan

`terraform apply plan.out` to apply the changes required to reach the desired state

`terraform destroy -var-file="local.tfvars"` to destroy the the Terraform-managed infrastructure
