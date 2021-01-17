data "aws_internet_gateway" "default" {
  filter {
    name   = "attachment.vpc-id"
    values = [data.aws_vpc.default.id]
  }
}
/* public (bastion)*/
resource "aws_route_table" "bastion" {
  vpc_id = data.aws_vpc.default.id

  tags = {
    Name = "rtb-bastion"
    Environment = "common"
  }
}
resource "aws_route" "bastion" {
  route_table_id            = aws_route_table.bastion.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id = data.aws_internet_gateway.default.id
}
//全てのデフォルトサブネットを紐付け
resource "aws_route_table_association" "bastion" {
  count = length(data.aws_subnet_ids.default.ids)

  subnet_id      = element(data.aws_subnet_ids.default.ids[*], count.index)
  route_table_id = aws_route_table.bastion.id
}
