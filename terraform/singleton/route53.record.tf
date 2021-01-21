resource "aws_route53_record" "ses_record" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "_amazonses.${var.common.domain_name}"
  type    = "TXT"
  ttl     = "600"
  records = [aws_ses_domain_identity.ses.verification_token]
}

resource "aws_route53_zone" "main" {
  name = var.common.domain_name
}

output "route53" {
  value = {
    main_zone_id = aws_route53_zone.main.zone_id
  }
}