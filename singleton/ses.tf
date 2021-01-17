
resource "aws_ses_domain_identity" "ses" {
  domain = var.common.domain_name
}


resource "aws_ses_domain_dkim" "dkim" {
  domain = var.common.domain_name
}

resource "aws_route53_record" "dkim_record" {
  count   = 3
  zone_id = aws_route53_zone.main.zone_id
  name    = "${element(aws_ses_domain_dkim.dkim.dkim_tokens, count.index)}._domainkey.${var.common.domain_name}"
  type    = "CNAME"
  ttl     = "600"
  records = ["${element(aws_ses_domain_dkim.dkim.dkim_tokens, count.index)}.dkim.amazonses.com"]
}