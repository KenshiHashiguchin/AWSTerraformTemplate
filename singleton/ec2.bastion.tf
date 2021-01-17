data "aws_ssm_parameter" "amzn2_ami" {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}
data "aws_subnet_ids" "default" {
  vpc_id = data.aws_vpc.default.id
}
resource "aws_instance" "bastion" {
  ami                  = data.aws_ssm_parameter.amzn2_ami.value
  ebs_optimized        = true
  instance_type        = var.ec2.bastion_instance_type
  key_name             = aws_key_pair.bastion.key_name
  vpc_security_group_ids = [aws_security_group.bastion.id]
  subnet_id = tolist(data.aws_subnet_ids.default.ids)[0]

  iam_instance_profile = aws_iam_instance_profile.bastion.name

  tags = {
    Name = "bastion-ec2"
    Environment = "common"
  }

  credit_specification {
    cpu_credits = "standard"
  }
}

resource "aws_inspector_resource_group" "bastion" {
  tags = {
    Name = "bastion-ec2"
    Environment = "common"
  }
}

resource "aws_inspector_assessment_target" "bastion" {
  name               = "ec2-bastion"
  resource_group_arn = aws_inspector_resource_group.bastion.arn
}

resource "aws_inspector_assessment_template" "bastion" {
  name       = "ec2-bastion"
  target_arn = aws_inspector_assessment_target.bastion.arn
  duration   = 3600

  rules_package_arns = data.aws_inspector_rules_packages.rules.arns
}

data "aws_inspector_rules_packages" "rules" {}

