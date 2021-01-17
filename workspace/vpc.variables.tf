locals {
  availability_zones     = var.vpc[terraform.workspace].availability_zones
  availability_zones_key = var.vpc[terraform.workspace].availability_zones_key
  public_cidr_blocks     = var.vpc[terraform.workspace].public_cidr_blocks
  app_cidr_blocks        = var.vpc[terraform.workspace].app_cidr_blocks
  datastore_cidr_blocks  = var.vpc[terraform.workspace].datastore_cidr_blocks
}
