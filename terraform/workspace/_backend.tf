terraform {
  backend "s3" {
    bucket = "kenshi-hashiguchi-terraform-tfstate"
    region = "ap-northeast-1"
    key = "terraform.workspace.tfstate"
    profile = "hashiguchi" #~/.aws/config
  }
}

data "terraform_remote_state" "singleton" {
  backend = "s3"

  config  = {
    bucket = "kenshi-hashiguchi-terraform-tfstate"
    region = "ap-northeast-1"
    key = "terraform.singleton.tfstate"
    profile = "hashiguchi" #~/.aws/config
  }
}