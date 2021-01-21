locals {
  //var.common.appsのリストと順番合わせること
  app_domains = [var.route53[terraform.workspace].app_user_domain ,var.route53[terraform.workspace].app_admin_domain]
}
//ALBルーティング
resource "aws_route53_record" "lb" {
  count = length(local.app_domains)

  name = element(local.app_domains, count.index)
  type = "CNAME"
  zone_id = data.terraform_remote_state.singleton.outputs.route53.main_zone_id
  ttl     = "60"
  records = [element(aws_lb.this.*.dns_name, count.index)]
}






