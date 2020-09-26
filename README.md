# Google Cloud Platform - Terraform VPC Module ![Kitchen Tests](https://github.com/lzysh/terraform-google-vpc/workflows/Kitchen%20Tests/badge.svg)

Terraform module for a Google Cloud Platform VPC.

## Usage

```hcl
module "shared-vpc" {
  source = "git@github.com:lzysh/terraform-google-vpc.git?ref=v1.1.0"
  
  project_id = module.project.project_id
  vpc_name   = "my-vpc"

  subnets = [
    {
      subnet_name      = "my-subnet-us-east4"
      subnet_range     = var.cidr_range
      subnet_region    = "us-east4"
      subnet_flow_logs = "true"
    },
  ]

  secondary_ranges = var.secondary_ranges
}
```
