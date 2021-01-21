resource "aws_iam_user" "ec2-user" {
  name = "${terraform.workspace}-ec2-user"
  path = "/ec2/"

  tags = {
    Name = "${terraform.workspace}-ec2-user"
    Environment = terraform.workspace
  }
}

resource "aws_iam_user_group_membership" "applications" {
  user = aws_iam_user.ec2-user.name
  groups = ["applications-group"]
}
