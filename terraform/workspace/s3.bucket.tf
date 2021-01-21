/*
    ALBログ
*/
resource "aws_s3_bucket" "lb_log_bucket" {
  bucket = "${terraform.workspace}-example-001-application-lb-access-logs"
  acl    = "private"

  tags = {
    Name        = "${terraform.workspace}-lb-access-logs"
    Environment = terraform.workspace
  }
}
resource "aws_s3_bucket_public_access_block" "lb_log_bucket" {
  bucket = aws_s3_bucket.lb_log_bucket.id

  block_public_acls   = true
  block_public_policy = true
  ignore_public_acls = true
  restrict_public_buckets = true
}
resource "aws_s3_bucket_policy" "alb_log" {
  bucket = aws_s3_bucket.lb_log_bucket.bucket
  policy = data.aws_iam_policy_document.alb_log.json
}

data "aws_iam_policy_document" "alb_log" {
  statement {
    effect    = "Allow"
    actions   = ["s3:PutObject"]
    resources = ["arn:aws:s3:::${aws_s3_bucket.lb_log_bucket.id}", "arn:aws:s3:::${aws_s3_bucket.lb_log_bucket.id}/*"]

    // The identifiers is the account ID.
    // https://docs.aws.amazon.com/ja_jp/elasticloadbalancing/latest/classic/enable-access-logs.html
    principals {
      type        = "AWS"
      identifiers = ["582318560864"] //Elastic Load Balancing 用の AWS アカウントの ID(ap-northeast-1)
    }
  }
}

