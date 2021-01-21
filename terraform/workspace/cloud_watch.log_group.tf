resource "aws_cloudwatch_log_group" "user_firelens_cluster_log_group" {
  name = "${terraform.workspace}/ecs/firelens"
}
