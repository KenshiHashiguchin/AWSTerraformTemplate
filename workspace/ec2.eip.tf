resource "aws_eip" "main-nat_gateway" {
  count = length(local.availability_zones_key)
  vpc = true

  tags = {
    Name = "${terraform.workspace}-eip-nat-${element(local.availability_zones_key, count.index)}"
    Environment = terraform.workspace
  }
}

