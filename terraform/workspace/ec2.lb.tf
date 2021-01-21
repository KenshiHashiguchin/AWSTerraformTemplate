resource "aws_lb" "this" {
  count              = length(var.common.apps)
  name               = "${terraform.workspace}-${element(var.common.apps, count.index)}-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = aws_security_group.lb.*.id
  subnets            = aws_subnet.main-public.*.id
  enable_deletion_protection = false

  access_logs {
    bucket  = aws_s3_bucket.lb_log_bucket.bucket
    prefix  = element(var.common.apps, count.index)
    enabled = true
  }

  tags = {
    Name = "${terraform.workspace}-${element(var.common.apps, count.index)}-lb"
    Environment = terraform.workspace
  }
}
//TargetGroup
resource "aws_lb_target_group" "this" {
  count = length(aws_lb.this.*.id)

  name     = "${element(aws_lb.this.*.name, count.index)}-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id

  tags = {
    Name = "${element(aws_lb.this.*.name, count.index)}-tg"
    Environment = terraform.workspace
  }
}
//Listener
resource "aws_lb_listener" "this" {
  count = length(aws_lb.this.*.arn)
  load_balancer_arn = element(aws_lb.this.*.arn, count.index)
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS-1-1-2017-01"
  certificate_arn   = data.terraform_remote_state.singleton.outputs.aws_acm_certificate.regional_arn

  default_action {
    type             = "forward"
    target_group_arn = element(aws_lb_target_group.this.*.arn, count.index)
  }
}

output "lb_target_group" {
  value = {
    user = {
      arn = aws_lb_target_group.this[0].arn
    }
    admin = {
      arn = aws_lb_target_group.this[1].arn
    }
  }
}
