data "aws_vpc" "default" { //bastion
  default = true
}

resource "aws_security_group" "bastion" {
  name        = "bastion-sg"
  vpc_id      = data.aws_vpc.default.id

  tags = {
    Name        = "bastion-sg"
    Environment = "common"
  }
}

resource "aws_security_group_rule" "bastion-ingress" {
  type              = "ingress"
  cidr_blocks       = var.vpc.allow_ssh_cidr_blocks
  from_port         = 22
  protocol          = "tcp"
  security_group_id = aws_security_group.bastion.id
  to_port           = 22
}

output "bastion" {
  value = {
    vpc_id = data.aws_vpc.default.id
    security_group_id = aws_security_group.bastion.id
    route_table_id = aws_route_table.bastion.id
  }
}
