terraform {
  backend "s3" {
    bucket = "kenshi-hashiguchi-terraform-tfstate"
    region = "ap-northeast-1"
    key = "terraform.singleton.tfstate"
    profile = "hashiguchi" #~/.aws/config
  }
}
