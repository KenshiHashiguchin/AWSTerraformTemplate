/* public */
resource "aws_route_table" "main-public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "${terraform.workspace}-rtb-main-igw"
    Environment = terraform.workspace
  }
}
resource "aws_route_table_association" "main-public" {
  count = length(local.availability_zones_key)

  subnet_id      = element(aws_subnet.main-public.*.id, count.index)
  route_table_id = aws_route_table.main-public.id
}

/* private */
resource "aws_route_table" "main-private" {
  count         = length(local.availability_zones_key)
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${terraform.workspace}-rtb-main-nat-${element(local.availability_zones_key, count.index)}"
    Environment = terraform.workspace
  }
}
resource "aws_route" "nat" {
  count                     = length(aws_route_table.main-private)
  route_table_id            = element(aws_route_table.main-private.*.id, count.index)
  destination_cidr_block    = "0.0.0.0/0"
  nat_gateway_id = element(aws_nat_gateway.main.*.id, count.index)
}

resource "aws_route_table_association" "main-app" {
  count         = length(local.availability_zones_key)

  subnet_id      = element(aws_subnet.main-app.*.id, count.index)
  route_table_id = element(aws_route_table.main-private.*.id, count.index)
}
resource "aws_route_table_association" "main-datastore" {
  count         = length(local.availability_zones_key)

  subnet_id      = element(aws_subnet.main-datastore.*.id, count.index)
  route_table_id = element(aws_route_table.main-private.*.id, count.index)
}

//各環境vpcのprivateルートテーブル -> bastion
resource "aws_route" "vpc_peering-requester" {
  count                     = length(aws_route_table.main-private)
  route_table_id            = element(aws_route_table.main-private.*.id, count.index)
  destination_cidr_block    = data.aws_vpc.default.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.this.id
}
//bastion -> 各環境vpcのprivateルートテーブル
resource "aws_route" "vpc_peering-accepter" {
  route_table_id            = data.terraform_remote_state.singleton.outputs.bastion.route_table_id
  destination_cidr_block    = aws_vpc.main.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.this.id
}