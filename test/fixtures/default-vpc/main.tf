module "test" {
  source = "../../../"

  project_id = ""

  subnets = [
    {
      subnet_name      = "lzysh-vpc-us-east4"
      subnet_range     = var.cidr_range
      subnet_region    = "us-east4"
      subnet_flow_logs = "true"
    },
  ]
}
