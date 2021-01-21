terraform {
  required_version = "= 0.14.3"
}

provider "aws" {
  region  = "ap-northeast-1"
  profile = "hashiguchi" #~/.aws/config
}

provider "aws" {
  alias = "global"

  profile = "hashiguchi"
  region  = "us-east-1"
}