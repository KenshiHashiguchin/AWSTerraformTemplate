/*　AWS VPC https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc　*/
resource "aws_vpc" "main" {

  assign_generated_ipv6_cidr_block = false
  cidr_block = var.vpc[terraform.workspace].vpc_cidr_block
  instance_tenancy = "default"
  enable_dns_support = true
  enable_dns_hostnames = true
  enable_classiclink = false
  enable_classiclink_dns_support = false

  tags = {
    Name = "${terraform.workspace}-main-vpc"
    Environment = terraform.workspace
  }
}

data "aws_vpc" "default" {
  default = true
}