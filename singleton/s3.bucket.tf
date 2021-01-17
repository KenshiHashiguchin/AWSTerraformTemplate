
resource "aws_s3_bucket" "tfstate" {
  bucket = var.s3.terraform_state_bucket
  versioning {
    enabled = true
  }
}

resource "aws_s3_bucket" "waf_log_bucket" {
  bucket = "application-waf-logs"
  acl    = "private"

  tags = {
    Name        = "waf-logs"
    Environment = "common"
  }
}

resource "aws_s3_bucket_public_access_block" "waf_log_bucket" {
  bucket = aws_s3_bucket.waf_log_bucket.id

  block_public_acls   = true
  block_public_policy = true
  ignore_public_acls = true
  restrict_public_buckets = true
}

output "s3" {
  value = {
    waf_log_bucket = {
      arn = aws_s3_bucket.waf_log_bucket.arn
    }
  }
}



