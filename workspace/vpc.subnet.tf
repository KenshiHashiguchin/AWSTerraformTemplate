resource "aws_subnet" "main-public" {
  vpc_id            = aws_vpc.main.id
  count             = length(local.availability_zones)
  availability_zone = element(local.availability_zones, count.index)
  cidr_block        = element(var.vpc[terraform.workspace].public_cidr_blocks, count.index)

  tags = {
    Name        = "${terraform.workspace}-public-${element(local.availability_zones_key, count.index)}"
    Environment = terraform.workspace
  }
}

resource "aws_subnet" "main-app" {
  vpc_id            = aws_vpc.main.id
  count             = length(local.availability_zones)
  availability_zone = element(local.availability_zones, count.index)
  cidr_block        = element(var.vpc[terraform.workspace].app_cidr_blocks, count.index)

  tags = {
    Name        = "${terraform.workspace}-app-${element(local.availability_zones_key, count.index)}"
    Environment = terraform.workspace
  }
}

resource "aws_subnet" "main-datastore" {
  vpc_id            = aws_vpc.main.id
  count             = length(local.availability_zones)
  availability_zone = element(local.availability_zones, count.index)
  cidr_block        = element(var.vpc[terraform.workspace].datastore_cidr_blocks, count.index)

  tags = {
    Name        = "${terraform.workspace}-datastore-${element(local.availability_zones_key, count.index)}"
    Environment = terraform.workspace
  }
}


