module "test" {
  source = "../../../"

  project_id = "ops-tf-child-module-testing"
  vpc_name   = "default-vpc"

  subnets = [
    {
      subnet_name      = "default-subnet-us-east4"
      subnet_range     = var.cidr_range
      subnet_region    = "us-east4"
      subnet_flow_logs = "true"
    },
  ]
}
