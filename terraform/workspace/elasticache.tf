
/*
resource "aws_elasticache_replication_group" "redis" {
  replication_group_id          = "${terraform.workspace}-redis"
  replication_group_description = "${terraform.workspace}-redis"
  node_type                     = var.elasticache[terraform.workspace].node_type

  automatic_failover_enabled    = true
  auto_minor_version_upgrade    = false
  engine                        = "redis"
  engine_version                = "6.x"

  at_rest_encryption_enabled    = true
  transit_encryption_enabled    = true

  auth_token                    = random_string.auth_token.result
  parameter_group_name          = "default.redis6.x.cluster.on"
  subnet_group_name             = aws_elasticache_subnet_group.redis.name
  security_group_ids            = [aws_security_group.db.id]

  maintenance_window            = "sat:19:00-sat:20:00"
  apply_immediately             = true

  cluster_mode {
    replicas_per_node_group = var.elasticache[terraform.workspace].replicas_per_node_group
    num_node_groups         = var.elasticache[terraform.workspace].num_node_groups
  }

  lifecycle {
    ignore_changes = [engine_version]
  }
}

resource "random_string" "auth_token" {
  length           = 32
  override_special = "!$%*-_=+[]{}?"
}

resource "aws_elasticache_subnet_group" "redis" {
  name        = "${terraform.workspace}-redis-subnet"
  subnet_ids  = aws_subnet.main-datastore.*.id
}

*/
