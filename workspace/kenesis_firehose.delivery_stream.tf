
resource "aws_kinesis_firehose_delivery_stream" "waf_log_stream" {
  name        = "aws-waf-logs-${terraform.workspace}-stream"
  destination = "s3"

  s3_configuration {
    role_arn   = data.terraform_remote_state.singleton.outputs.iam.firehose_role.arn
    bucket_arn = data.terraform_remote_state.singleton.outputs.s3.waf_log_bucket.arn

    prefix = "${terraform.workspace}/"
  }

  tags = {
    Name        = "${terraform.workspace}-waf-logs"
    Environment = terraform.workspace
  }
}








