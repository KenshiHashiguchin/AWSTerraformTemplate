resource "aws_nat_gateway" "main" {
  count         = length(local.availability_zones_key)
  allocation_id = element(aws_eip.main-nat_gateway.*.id, count.index) //var.vpc["subnet-fronts"]
  subnet_id     = element(aws_subnet.main-public.*.id, count.index)

  tags = {
    Name = "${terraform.workspace}-nat-main-${element(local.availability_zones_key, count.index)}"
    Environment = terraform.workspace
  }
}
