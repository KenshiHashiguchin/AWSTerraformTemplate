//作成・削除のみしか行わない(valueを変更しても、valueの更新はされない。valueを変更する場合はコンソールから都度修正)
//バックエンド(laravel)側のENVはuser用, admin用２つ用意する
locals {
  backend_path = "/${terraform.workspace}/app/backend"
}

//Laravel backend

//resource "aws_ssm_parameter" "backend_app_env" {
//  count = length(var.common["apps"])
//  name  = "${local.backend_path}/${element(var.common["apps"], count.index)}/APP_ENV"
//  type  = "String"
//  value = var.ssm[terraform.workspace].aws_ssm_parameter.app_env
//}
//resource "aws_ssm_parameter" "backend_app_name" {
//  count = length(var.common["apps"])
//  name  = "${local.backend_path}/${element(var.common["apps"], count.index)}/APP_NAME"
//  type  = "String"
//  value = "NeoSports"
//}
//resource "aws_ssm_parameter" "backend_app_key" {
//  count = length(var.common["apps"])
//  name  = "${local.backend_path}/${element(var.common["apps"], count.index)}/APP_KEY"
//  type  = "String"
//  value = "base64:SJERAlqcGJp0J8fhYCAuLdmDB6Q2gJhXrSWGmaRL9wI="
//}
//resource "aws_ssm_parameter" "backend_app_debug" {
//  count = length(var.common["apps"])
//  name  = "${local.backend_path}/${element(var.common["apps"], count.index)}/APP_DEBUG"
//  type  = "String"
//  value = "false"
//}
//resource "aws_ssm_parameter" "backend_domain_user" {
//  count = length(var.common["apps"])
//  name  = "${local.backend_path}/${element(var.common["apps"], count.index)}/DOMAIN_USER"
//  type  = "String"
//  value = var.route53[terraform.workspace].app_user_domain
//}
//resource "aws_ssm_parameter" "backend_domain_admin" {
//  count = length(var.common["apps"])
//  name  = "${local.backend_path}/${element(var.common["apps"], count.index)}/DOMAIN_ADMIN"
//  type  = "String"
//  value = var.route53[terraform.workspace].app_admin_domain
//}
//resource "aws_ssm_parameter" "backend_app_url" {
//  count = length(var.common["apps"])
//  name  = "${local.backend_path}/${element(var.common["apps"], count.index)}/APP_URL"
//  type  = "String"
//  //todo 正しいかチェック
//  value = element(var.common["apps"], count.index) == "user" ? var.application[terraform.workspace].app_user_url : var.application[terraform.workspace].app_admin_url
//}
//resource "aws_ssm_parameter" "backend_front_url" {
//  count = length(var.common["apps"])
//  name  = "${local.backend_path}/${element(var.common["apps"], count.index)}/FRONT_URL"
//  type  = "String"
//  value = var.application[terraform.workspace].app_user_url
//}
//resource "aws_ssm_parameter" "backend_session_secure_cookie" {
//  count = length(var.common["apps"])
//  name  = "${local.backend_path}/${element(var.common["apps"], count.index)}/SESSION_SECURE_COOKIE"
//  type  = "String"
//  value = "false"
//}
//resource "aws_ssm_parameter" "backend_log_channel" {
//  count = length(var.common["apps"])
//  name  = "${local.backend_path}/${element(var.common["apps"], count.index)}/LOG_CHANNEL"
//  type  = "String"
//  value = "stack"
//}
//resource "aws_ssm_parameter" "backend_db_connection" {
//  count = length(var.common["apps"])
//  name  = "${local.backend_path}/${element(var.common["apps"], count.index)}/DB_CONNECTION"
//  type  = "String"
//  value = "mysql"
//}
//resource "aws_ssm_parameter" "backend_db_host" {
//  count = length(var.common["apps"])
//  name  = "${local.backend_path}/${element(var.common["apps"], count.index)}/DB_HOST"
//  type  = "String"
//  value = "db_host"
//  lifecycle {
//    ignore_changes = [value]
//  }
//}
//resource "aws_ssm_parameter" "backend_db_port" {
//  count = length(var.common["apps"])
//  name  = "${local.backend_path}/${element(var.common["apps"], count.index)}/DB_PORT"
//  type  = "String"
//  value = "3306"
//}
//resource "aws_ssm_parameter" "backend_db_database" {
//  count = length(var.common["apps"])
//  name  = "${local.backend_path}/${element(var.common["apps"], count.index)}/DB_DATABASE"
//  type  = "String"
//  value = var.rds[terraform.workspace].db_name
//}
//resource "aws_ssm_parameter" "backend_db_username" {
//  count = length(var.common["apps"])
//  name  = "${local.backend_path}/${element(var.common["apps"], count.index)}/DB_USERNAME"
//  type  = "String"
//  value = "application"
//  lifecycle {
//    ignore_changes = [value]
//  }
//}
//resource "aws_ssm_parameter" "backend_db_password" {
//  count = length(var.common["apps"])
//  name  = "${local.backend_path}/${element(var.common["apps"], count.index)}/DB_PASSWORD"
//  type  = "SecureString"
//  value = "db_password"
//  lifecycle {
//    ignore_changes = [value]
//  }
//}
//resource "aws_ssm_parameter" "backend_cache_driver" {
//  count = length(var.common["apps"])
//  name  = "${local.backend_path}/${element(var.common["apps"], count.index)}/CACHE_DRIVER"
//  type  = "String"
//  value = "redis"
//}
//resource "aws_ssm_parameter" "backend_queue_connection" {
//  count = length(var.common["apps"])
//  name  = "${local.backend_path}/${element(var.common["apps"], count.index)}/QUEUE_CONNECTION"
//  type  = "String"
//  value = "sync"
//}
//resource "aws_ssm_parameter" "backend_session_driver" {
//  count = length(var.common["apps"])
//  name  = "${local.backend_path}/${element(var.common["apps"], count.index)}/SESSION_DRIVER"
//  type  = "String"
//  value = "redis"
//}
//resource "aws_ssm_parameter" "backend_session_lifetime" {
//  count = length(var.common["apps"])
//  name  = "${local.backend_path}/${element(var.common["apps"], count.index)}/SESSION_LIFETIME"
//  type  = "String"
//  value = "120"
//}
//resource "aws_ssm_parameter" "backend_redis_scheme" {
//  count = length(var.common["apps"])
//  name  = "${local.backend_path}/${element(var.common["apps"], count.index)}/REDIS_SCHEME"
//  type  = "String"
//  value = "tls"
//}
//resource "aws_ssm_parameter" "backend_redis_host" {
//  count = length(var.common["apps"])
//  name  = "${local.backend_path}/${element(var.common["apps"], count.index)}/REDIS_HOST"
//  type  = "String"
//  value = "redis_host"
//  lifecycle {
//    ignore_changes = [value]
//  }
//}
//resource "aws_ssm_parameter" "backend_redis_password" {
//  count = length(var.common["apps"])
//  name  = "${local.backend_path}/${element(var.common["apps"], count.index)}/REDIS_PASSWORD"
//  type  = "SecureString"
//  value = "redis_password"
//  lifecycle {
//    ignore_changes = [value]
//  }
//}
//resource "aws_ssm_parameter" "backend_redis_port" {
//  count = length(var.common["apps"])
//  name  = "${local.backend_path}/${element(var.common["apps"], count.index)}/REDIS_PORT"
//  type  = "String"
//  value = "6379"
//}
//resource "aws_ssm_parameter" "backend_mail_driver" {
//  count = length(var.common["apps"])
//  name  = "${local.backend_path}/${element(var.common["apps"], count.index)}/MAIL_DRIVER"
//  type  = "String"
//  value = "smtp"
//}
//resource "aws_ssm_parameter" "backend_mail_host" {
//  count = length(var.common["apps"])
//  name  = "${local.backend_path}/${element(var.common["apps"], count.index)}/MAIL_HOST"
//  type  = "String"
//  value = "email-smtp.ap-northeast-1.amazonaws.com" //AWS SES
//}
//resource "aws_ssm_parameter" "backend_mail_port" {
//  count = length(var.common["apps"])
//  name  = "${local.backend_path}/${element(var.common["apps"], count.index)}/MAIL_PORT"
//  type  = "String"
//  value = "465"
//}
//resource "aws_ssm_parameter" "backend_mail_username" {
//  count = length(var.common["apps"])
//  name  = "${local.backend_path}/${element(var.common["apps"], count.index)}/MAIL_USERNAME"
//  type  = "String"
//  value = "mail_username"
//  lifecycle {
//    ignore_changes = [value]
//  }
//}
//resource "aws_ssm_parameter" "backend_mail_password" {
//  count = length(var.common["apps"])
//  name  = "${local.backend_path}/${element(var.common["apps"], count.index)}/MAIL_PASSWORD"
//  type  = "SecureString"
//  value = "mail_password"
//  lifecycle {
//    ignore_changes = [value]
//  }
//}
//resource "aws_ssm_parameter" "backend_mail_encryption" {
//  count = length(var.common["apps"])
//  name  = "${local.backend_path}/${element(var.common["apps"], count.index)}/MAIL_ENCRYPTION"
//  type  = "String"
//  value = "ssl"
//}
//resource "aws_ssm_parameter" "backend_mail_from_address" {
//  count = length(var.common["apps"])
//  name  = "${local.backend_path}/${element(var.common["apps"], count.index)}/MAIL_FROM_ADDRESS"
//  type  = "String"
//  value = "info@waitfull.com"
//}
//resource "aws_ssm_parameter" "backend_mail_from_name" {
//  count = length(var.common["apps"])
//  name  = "${local.backend_path}/${element(var.common["apps"], count.index)}/MAIL_FROM_NAME"
//  type  = "String"
//  value = "運営チーム"
//}
//resource "aws_ssm_parameter" "backend_aws_access_key_id" {
//  count = length(var.common["apps"])
//  name  = "${local.backend_path}/${element(var.common["apps"], count.index)}/AWS_ACCESS_KEY_ID"
//  type  = "SecureString"
//  value = "aws_access_key_id"
//  lifecycle {
//    ignore_changes = [value]
//  }
//}
//resource "aws_ssm_parameter" "backend_aws_secret_access_key" {
//  count = length(var.common["apps"])
//  name  = "${local.backend_path}/${element(var.common["apps"], count.index)}/AWS_SECRET_ACCESS_KEY"
//  type  = "SecureString"
//  value = "aws_secret_access_key"
//  lifecycle {
//    ignore_changes = [value]
//  }
//}
//resource "aws_ssm_parameter" "backend_aws_default_region" {
//  count = length(var.common["apps"])
//  name  = "${local.backend_path}/${element(var.common["apps"], count.index)}/AWS_DEFAULT_REGION"
//  type  = "String"
//  value = "ap-northeast-1"
//}
//resource "aws_ssm_parameter" "backend_aws_bucket" {
//  count = length(var.common["apps"])
//  name  = "${local.backend_path}/${element(var.common["apps"], count.index)}/AWS_BUCKET"
//  type  = "String"
//  value = "${terraform.workspace}-neosports-applications"
//}
//resource "aws_ssm_parameter" "backend_line_key" {
//  count = length(var.common["apps"])
//  name  = "${local.backend_path}/${element(var.common["apps"], count.index)}/LINE_KEY"
//  type  = "SecureString"
//  value = "line_key"
//  lifecycle {
//    ignore_changes = [value]
//  }
//}
//resource "aws_ssm_parameter" "backend_line_secret" {
//  count = length(var.common["apps"])
//  name  = "${local.backend_path}/${element(var.common["apps"], count.index)}/LINE_SECRET"
//  type  = "SecureString"
//  value = "line_secret"
//  lifecycle {
//    ignore_changes = [value]
//  }
//}
//resource "aws_ssm_parameter" "backend_line_redirect_uri" {
//  count = length(var.common["apps"])
//  name  = "${local.backend_path}/${element(var.common["apps"], count.index)}/LINE_REDIRECT_URI"
//  type  = "String"
//  value = "${var.application[terraform.workspace].app_user_url}/auth/login/line/callback"
//}
//resource "aws_ssm_parameter" "backend_google_api_id" {
//  count = length(var.common["apps"])
//  name  = "${local.backend_path}/${element(var.common["apps"], count.index)}/GOOGLE_API_ID"
//  type  = "SecureString"
//  value = "google_api_id"
//  lifecycle {
//    ignore_changes = [value]
//  }
//}
//resource "aws_ssm_parameter" "backend_google_api_secret" {
//  count = length(var.common["apps"])
//  name  = "${local.backend_path}/${element(var.common["apps"], count.index)}/GOOGLE_API_SECRET"
//  type  = "SecureString"
//  value = "google_api_secret"
//  lifecycle {
//    ignore_changes = [value]
//  }
//}
//resource "aws_ssm_parameter" "backend_google_callback_url" {
//  count = length(var.common["apps"])
//  name  = "${local.backend_path}/${element(var.common["apps"], count.index)}/GOOGLE_CALLBACK_URL"
//  type  = "String"
//  value = "${var.application[terraform.workspace].app_user_url}/auth/login/google/callback"
//}
//resource "aws_ssm_parameter" "backend_twitter_client_id" {
//  count = length(var.common["apps"])
//  name  = "${local.backend_path}/${element(var.common["apps"], count.index)}/TWITTER_CLIENT_ID"
//  type  = "SecureString"
//  value = "twitter_client_id"
//  lifecycle {
//    ignore_changes = [value]
//  }
//}
//resource "aws_ssm_parameter" "backend_twitter_client_secret" {
//  count = length(var.common["apps"])
//  name  = "${local.backend_path}/${element(var.common["apps"], count.index)}/TWITTER_CLIENT_SECRET"
//  type  = "SecureString"
//  value = "twitter_client_secret"
//  lifecycle {
//    ignore_changes = [value]
//  }
//}
//resource "aws_ssm_parameter" "backend_twitter_callback_url" {
//  count = length(var.common["apps"])
//  name  = "${local.backend_path}/${element(var.common["apps"], count.index)}/TWITTER_CALLBACK_URL"
//  type  = "String"
//  value = "${var.application[terraform.workspace].app_user_url}/auth/login/twitter/callback"
//}
//
//resource "aws_ssm_parameter" "backend_passport_public_key" {
//  count = length(var.common["apps"])
//  name  = "${local.backend_path}/${element(var.common["apps"], count.index)}/PASSPORT_PUBLIC_KEY"
//  type  = "SecureString"
//  value = "PASSPORT_PUBLIC_KEY"
//  lifecycle {
//    ignore_changes = [value]
//  }
//}
//resource "aws_ssm_parameter" "backend_passport_private_key" {
//  count = length(var.common["apps"])
//  name  = "${local.backend_path}/${element(var.common["apps"], count.index)}/PASSPORT_PRIVATE_KEY"
//  type  = "SecureString"
//  value = "PASSPORT_PRIVATE_KEY"
//  lifecycle {
//    ignore_changes = [value]
//  }
//}


