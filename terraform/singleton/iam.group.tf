/*
    EC2インスタンスのアプリケーションに配置するユーザのグループ
*/
resource "aws_iam_group" "applications" {
  name = "applications-group"
  path = "/ec2/"
}

/*
  TODO 用件によって権限を絞ること
*/
resource "aws_iam_group_policy_attachment" "this-cloudwatch" {
  group      = aws_iam_group.applications.name
  policy_arn = data.aws_iam_policy.cloudwatch-logs-full-access.arn
}
resource "aws_iam_group_policy_attachment" "this-s3" {
  group      = aws_iam_group.applications.name
  policy_arn = data.aws_iam_policy.amazon-s3-full-access.arn
}
data "aws_iam_policy" "cloudwatch-logs-full-access" {
  arn = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
}

data "aws_iam_policy" "amazon-s3-full-access" {
  arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

#SES send mail 権限
resource "aws_iam_user_policy" "ses" {
  name = "ses-send-role"
  policy = data.aws_iam_policy_document.ses-send-mail.json
  user = aws_iam_user.ses.name
}

data "aws_iam_policy_document" "ses-send-mail" {
  statement {
    actions = ["ses:SendRawEmail", "ses:SendEmail"]
    effect = "Allow"
    resources = ["*"]
  }
}



