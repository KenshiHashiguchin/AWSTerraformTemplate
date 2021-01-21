//bastion<->環境-vpc ピアリング接続
resource "aws_vpc_peering_connection" "this" {
  peer_owner_id = aws_vpc.main.owner_id
  peer_vpc_id   = aws_vpc.main.id
  vpc_id        = data.terraform_remote_state.singleton.outputs.bastion.vpc_id
  peer_region   = "ap-northeast-1"
  auto_accept = false

  tags = {
    Name        = "${terraform.workspace}-bastion-pcx-requester"
    Environment = terraform.workspace
  }
}
//
# Accepter's side of the connection.
resource "aws_vpc_peering_connection_accepter" "this" {
  vpc_peering_connection_id = aws_vpc_peering_connection.this.id
  auto_accept               = true

  tags = {
    Name        = "${terraform.workspace}-bastion-pcx-accepter"
    Environment = terraform.workspace
  }
}