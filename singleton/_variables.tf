variable "common" {
  default = {
    domain_name = "waitfull.com"
  }
}

variable "vpc" {
  default = {
    //TODO 許可IP 踏み台経由のssh接続
    allow_ssh_cidr_blocks = ["126.99.221.108/32"]
  }
}

variable "ec2" {
  default = {
    bastion_instance_type = "t3.nano"
  }
}

variable "s3" {
  default = {
    terraform_state_bucket = "kenshi-hashiguchi-terraform-tfstate"
  }
}