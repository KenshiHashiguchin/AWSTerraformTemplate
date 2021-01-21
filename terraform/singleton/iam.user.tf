resource "aws_iam_user" "ses" {
  name = "ses-send-user"
  path = "/aws/ses/"

  tags = {
    "Name" = "iam-user-ses"
    "Environment" = "common"
  }
}
