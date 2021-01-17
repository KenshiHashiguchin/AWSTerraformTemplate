# AWSTerraformTemplate

## 概要
Webアプリケーションインフラの基本的なアーキテクチャを構築するためのTerraformテンプレート


## 必要環境・セットアップ
### AWS CLI (バージョン2系)
・インストール
　　https://docs.aws.amazon.com/ja_jp/cli/latest/userguide/install-cliv2.html
　　Macの場合：https://awscli.amazonaws.com/AWSCLIV2.pkg

```
aws configure --profile terraform
> AWS Access Key ID [None]: <your access key>
> AWS Secret Access Key [None]: <your secret access key>
> Default region name [None]: ap-northeast-1
> Default output format [None]: json
```

### Terraform v0.14.3
・インストール
　　Macの場合：brew install terraform

## Terraformワークスペース
### ・AWSTerraformTemplate/singleton
```
cd AWSTerraformTemplate/singleton
terraform init
terraform plan
terraform apply
```
SESのような環境毎に用意する必要のないリソースを管理
- SES
- ACM(証明書)
- EC2(bastion)
- EIP(bastion)
- Route53(host zone)
- S3(tfstate, log系)


### ・AWSTerraformTemplate/workspace
```
cd AWSTerraformTemplate/workspace
terraform workspace new dev
terraform workspace select dev
terraform init
terraform plan
terraform apply
```
開発環境・本番環境毎に用意するリソースを管理
- CloudWatch
- EC2
  - ECSコンテナインスタンス
  - 起動テンプレート
  - ALB
  - Auto Scaling グループ
- VPC
  - ピアリング接続
  - サブネット
  - ルートテーブル
  - ネットワークACL
  - セキュリティグループ
- Route53
- WAF
- Ki