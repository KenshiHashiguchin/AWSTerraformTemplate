//ACM証明書

//グローバル
resource "aws_acm_certificate" "global" {
  provider = aws.global

  domain_name       = var.common.domain_name
  subject_alternative_names = ["*.${var.common.domain_name}"]
  validation_method = "DNS"

  tags = {
    Name = "${var.common.domain_name}:us-east-1"
    Environment = "common"
  }
}


//ACM 検証用レコード作成
resource "aws_route53_record" "cert_validation" {
  zone_id = aws_route53_zone.main.zone_id
  name    = element(aws_acm_certificate.global.domain_validation_options.*.resource_record_name, 0)
  type    = element(aws_acm_certificate.global.domain_validation_options.*.resource_record_type, 0)
  records = [element(aws_acm_certificate.global.domain_validation_options.*.resource_record_value, 0)]
  ttl     = 60
}

resource "aws_acm_certificate_validation" "global" {
  provider = aws.global

  certificate_arn = aws_acm_certificate.global.arn
  validation_record_fqdns = [aws_route53_record.cert_validation.fqdn]
}

//ap-north-east
resource "aws_acm_certificate" "regional" {
  domain_name       = var.common.domain_name
  subject_alternative_names = ["*.${var.common.domain_name}"]
  validation_method = "DNS"

  tags = {
    Name = "${var.common.domain_name}:ap-northeast-1"
    Environment = "common"
  }
}
resource "aws_acm_certificate_validation" "regional" {
  certificate_arn = aws_acm_certificate.regional.arn
  validation_record_fqdns = [aws_route53_record.cert_validation.fqdn]
}
output "aws_acm_certificate" {
  value = {
    global_arn = aws_acm_certificate.global.arn
    regional_arn = aws_acm_certificate.regional.arn
  }
}
