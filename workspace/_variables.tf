variable "common" {
  default = {
    apps = ["user", "admin"] //順番変えない・文字列変えないこと・値追加する場合は、他のリソースを手動で追加する必要あり(ex:ec2.auto_scaling.tf etc)
    domain = "waitfull.com"
  }
}



variable "vpc" {
  default = {
//    prd = {
//      vpc_cidr_block = "172.16.0.0/16"
//    }
    dev = {
      vpc_cidr_block = "172.17.0.0/16"

      //ap-northeast-1d追加すれば、他のリソースも自動で構築できるわけではないのであしからず
      availability_zones = ["ap-northeast-1a", "ap-northeast-1c"]
      availability_zones_key = ["a", "c"]

      #index=0:ap-northeast-1a, index=1:ap-northeast-1c
      public_cidr_blocks         = ["172.17.1.0/24", "172.17.2.0/24"]
      app_cidr_blocks            = ["172.17.3.0/24", "172.17.4.0/24"]
      datastore_cidr_blocks      = ["172.17.5.0/24", "172.17.6.0/24"]
      instance_allow_cidr_blocks = ["126.99.221.108/32"] //my home ip
    }
  }
}

variable "route53" {
  default = {
    dev = {
      app_user_domain   = "dev-www.waitfull.com"
      app_admin_domain   = "dev-admin.waitfull.com"
    }
  }
}

variable "ssm" {
  default = {
    dev = {
      aws_ssm_parameter = {
        app_env = "develop"
        app_name = "Application"
      }
    }
  }
}


variable "ec2" {
  default = {
    image_id = "ami-08c834e58473d808d" //ECS amzn2-ami-ecs-hvm-2.0.20201130-x86_64-ebs
    dev = {
      instance_type     = "t3.small"
      desired_capacity  = 1
      max_size          = 1
      min_size          = 1
      market_type       = "spot"
      core_count        = 1
      threads_per_core        = 2

      //ECS https://docs.aws.amazon.com/ja_jp/AmazonECS/latest/developerguide/ecs-agent-config.html
      ecs_engine_task_cleanup_wait_duration = "30m"
    }
  }
}

variable "rds" {
  default = {
    dev = {
      db_name        = "applications_db"
      instance_type  = "db.t3.small"
      master_username = "master"
      master_password = "temp" //todo Concealment
    }
  }
}

variable "application" {
  default = {
    dev = {
      app_user_url = "https://dev-www.waitfull.com"
      app_admin_url = "https://dev-admin.waitfull.com"
    }
  }
}

variable "elasticache" {
  default = {
    dev = {
      node_type = "cache.t3.micro"
      replicas_per_node_group = 1
      num_node_groups         = 1
    }
  }
}