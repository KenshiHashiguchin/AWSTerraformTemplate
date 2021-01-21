
//ALB用セキュリティグループ
resource "aws_security_group" "lb" {
  count       = length(var.common.apps)

  name        = "${terraform.workspace}-${element(var.common.apps, count.index)}-lb-sg"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "${terraform.workspace}-${element(var.common.apps, count.index)}-lb-sg"
    Environment = terraform.workspace
  }
}
resource "aws_security_group_rule" "lb-ingress-https" {
  count       = length(aws_security_group.lb)

  type              = "ingress"
  cidr_blocks = var.vpc[terraform.workspace].instance_allow_cidr_blocks

  from_port         = 443
  protocol          = "tcp"
  security_group_id = element(aws_security_group.lb.*.id, count.index)
  to_port           = 443
}
resource "aws_security_group_rule" "lb-egress-http" {
  count       = length(aws_security_group.lb)
  from_port                = 32768
  to_port                  = 61000

  type                     = "egress"
  protocol                 = "tcp"
  security_group_id        = element(aws_security_group.lb.*.id, count.index)
  source_security_group_id = element(aws_security_group.instance.*.id, count.index)
}


//EC2インスタンス用セキュリティグループ
resource "aws_security_group" "instance" {
  count       = length(var.common.apps)

  name        = "${terraform.workspace}-${element(var.common.apps, count.index)}-instance-sg"
//  description = "Allow TCP Traffic"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "${terraform.workspace}-${element(var.common.apps, count.index)}-instance-sg"
    Environment = terraform.workspace
  }
}
resource "aws_security_group_rule" "instance-ingress-http" {
  count       = length(aws_security_group.instance)

  //動的ポートマッピング
  //https://docs.aws.amazon.com/ja_jp/AmazonECS/latest/userguide/load-balancer-types.html
  from_port                = 32768
  to_port                  = 61000

  type                     = "ingress"
  protocol                 = "tcp"
  security_group_id        = element(aws_security_group.instance.*.id, count.index)
  source_security_group_id = element(aws_security_group.lb.*.id, count.index)
}
resource "aws_security_group_rule" "instance-ingress-bastion" {
  count       = length(aws_security_group.instance)

  type                     = "ingress"
  from_port                = 22
  protocol                 = "tcp"
  security_group_id        = element(aws_security_group.instance.*.id, count.index)
  source_security_group_id = data.terraform_remote_state.singleton.outputs.bastion.security_group_id
  to_port                  = 22
}
resource "aws_security_group_rule" "instance-egress-http" {
  count       = length(aws_security_group.instance)

  type              = "egress"
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 80
  protocol          = "tcp"
  security_group_id = element(aws_security_group.instance.*.id, count.index)
  to_port           = 80
}
resource "aws_security_group_rule" "instance-egress-https" {
  count       = length(aws_security_group.instance)

  type              = "egress"
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 443
  protocol          = "tcp"
  security_group_id = element(aws_security_group.instance.*.id, count.index)
  to_port           = 443
}
resource "aws_security_group_rule" "instance-egress-db" {
  count       = length(aws_security_group.instance)

  type              = "egress"
  from_port         = 3306
  protocol          = "tcp"
  security_group_id = element(aws_security_group.instance.*.id, count.index)
  source_security_group_id = aws_security_group.db.id
  to_port           = 3306
}
resource "aws_security_group_rule" "instance-egress-redis" {
  count       = length(aws_security_group.instance)

  type              = "egress"
  from_port         = 6379
  protocol          = "tcp"
  security_group_id = element(aws_security_group.instance.*.id, count.index)
  source_security_group_id = aws_security_group.db.id
  to_port           = 6379
}

//データベース用セキュリティグループ
resource "aws_security_group" "db" {
  name        = "${terraform.workspace}-db-sg"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "${terraform.workspace}-db-sg"
    Environment = terraform.workspace
  }
}
resource "aws_security_group_rule" "db-ingress" {
  count = length(aws_security_group.instance.*.id)
  type                     = "ingress"
  from_port                = 3306
  protocol                 = "tcp"
  security_group_id        = aws_security_group.db.id
  source_security_group_id = element(aws_security_group.instance.*.id, count.index)
  to_port                  = 3306
}
resource "aws_security_group_rule" "redis-ingress" {
  count = length(aws_security_group.instance.*.id)
  type                     = "ingress"
  from_port                = 6379
  protocol                 = "tcp"
  security_group_id        = aws_security_group.db.id
  source_security_group_id = element(aws_security_group.instance.*.id, count.index)
  to_port                  = 6379
}
resource "aws_security_group_rule" "db-ingress-bastion" {
  type                     = "ingress"
  from_port                = 3306
  protocol                 = "tcp"
  security_group_id        = aws_security_group.db.id
  source_security_group_id = data.terraform_remote_state.singleton.outputs.bastion.security_group_id
  to_port                  = 3306
}



//bastion アウトバウンド定義
resource "aws_security_group_rule" "bastion-egress-db" {
  type                     = "egress"
  from_port                = 3306
  protocol                 = "tcp"
  security_group_id        = data.terraform_remote_state.singleton.outputs.bastion.security_group_id
  source_security_group_id = aws_security_group.db.id
  to_port                  = 3306
}
resource "aws_security_group_rule" "bastion-egress-instance" {
  count       = length(aws_security_group.instance)

  type                     = "egress"
  from_port                = 22
  protocol                 = "tcp"
  security_group_id        = data.terraform_remote_state.singleton.outputs.bastion.security_group_id
  source_security_group_id = element(aws_security_group.instance.*.id, count.index)
  to_port                  = 22
}
