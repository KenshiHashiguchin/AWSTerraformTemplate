
/*
resource "aws_rds_cluster_instance" "this" {
  count              = 2
  identifier         = "${terraform.workspace}-${count.index}"
  cluster_identifier = aws_rds_cluster.this.id
  instance_class     = var.rds[terraform.workspace].instance_type
  engine             = aws_rds_cluster.this.engine
  engine_version     = aws_rds_cluster.this.engine_version
  publicly_accessible = false
  db_subnet_group_name = aws_db_subnet_group.this.name
  copy_tags_to_snapshot = true

  tags = {
    Name = "${terraform.workspace}-aurora-cluster-instance-${count.index}"
    Environment = terraform.workspace
  }
}

resource "aws_rds_cluster" "this" {
  cluster_identifier      = "${terraform.workspace}-aurora-cluster"
  engine                  = "aurora-mysql"
  engine_version          = "5.7.mysql_aurora.2.09.0"
  availability_zones      = ["ap-northeast-1a", "ap-northeast-1c"]
  database_name           = var.rds[terraform.workspace].db_name
  master_username         = var.rds[terraform.workspace].master_username
  master_password         = var.rds[terraform.workspace].master_password
  backup_retention_period = 5
  preferred_backup_window = "16:00-17:00" //JST 02:00-05:00
  preferred_maintenance_window = "Fri:18:00-Fri:19:00"
  final_snapshot_identifier = "${terraform.workspace}-aurora-cluster-final"
  skip_final_snapshot  = false
  db_subnet_group_name = aws_db_subnet_group.this.name
  vpc_security_group_ids = [aws_security_group.db.id]
  enabled_cloudwatch_logs_exports = ["audit", "error", "general", "slowquery"]

  tags = {
    Name = "${terraform.workspace}-aurora-cluster"
    Environment = terraform.workspace
  }

  lifecycle {
    ignore_changes = [master_password, availability_zones]
  }
}

resource "aws_db_subnet_group" "this" {
  name       = "${terraform.workspace}-aurora-sg"
  subnet_ids = aws_subnet.main-datastore.*.id

  tags = {
    Name = "${terraform.workspace}-aurora-sg"
    Environment = terraform.workspace
  }
}
*/