


//bastion
resource "aws_iam_role" "bastion" {
  name               = "bastion-role"
  assume_role_policy = data.aws_iam_policy_document.bastion.json

  tags = {
    Name = "bastion-role"
    Environment = "common"
  }
}
data "aws_iam_policy_document" "bastion" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type = "AWS"
      //STS セッショントークン取得用 //TODO 後々公式なものに差し替え
      identifiers = ["arn:aws:iam::083933988942:user/ss-hashiguchi"]
    }
    principals {
      type = "Service"
      identifiers = [
        "ec2.amazonaws.com",
        "ssm.amazonaws.com",
      ]
    }
  }
}
resource "aws_iam_instance_profile" "bastion" {
  name = "bastion-profile"
  role = aws_iam_role.bastion.name
}
resource "aws_iam_role_policy_attachment" "bastion-ssm" {
  role       = aws_iam_role.bastion.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"
}
resource "aws_iam_role_policy_attachment" "bastion-cloudwatch" {
  role       = aws_iam_role.bastion.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}
resource "aws_iam_role_policy_attachment" "bastion-ecs" {
  role       = aws_iam_role.bastion.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonECS_FullAccess"
}
resource "aws_iam_role_policy_attachment" "bastion-ecr" {
  role       = aws_iam_role.bastion.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess"
}

resource "aws_iam_role" "ecs_task_execution_role" {
  name = "ecs_task_execution_role"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_execution_role.json
}
data "aws_iam_policy_document" "ecs_task_execution_role" {
  statement {
    actions = ["sts:AssumeRole"]
    effect = "Allow"
    principals {
      type = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}
resource "aws_iam_role_policy_attachment" "ecs-task-execution-policy" {
  role = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy_attachment" "ecr-read-policy" {
  role = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMReadOnlyAccess"
}

output "instance_profile" {
  value = {
    bastion = {
      name = aws_iam_instance_profile.bastion.name
    }
  }
}


//AWS Kinesis Data Firehose WAF Logs
resource "aws_iam_role" "firehose_role" {
  name = "firehose_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "firehose.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "firehose_role_attachment" {
  role       = aws_iam_role.firehose_role.name
  policy_arn = aws_iam_policy.firehose_s3_policy.arn
}

resource "aws_iam_policy" "firehose_s3_policy" {
  name        = "firehose_s3_policy"
  path        = "/"

  policy = data.aws_iam_policy_document.firehose_s3_policy.json
}

data "aws_iam_policy_document" "firehose_s3_policy" {
  statement {
    effect = "Allow"
    actions = ["s3:AbortMultipartUpload", "s3:GetBucketLocation", "s3:GetObject", "s3:ListBucket", "s3:ListBucketMultipartUploads", "s3:PutObject" ]
    resources = ["arn:aws:s3:::application-waf-logs", "arn:aws:s3:::application-waf-logs/*"]
  }
}

output "iam" {
  value = {
    firehose_role = {
      arn = aws_iam_role.firehose_role.arn
    }
  }
}

