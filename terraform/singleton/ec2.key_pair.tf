resource "aws_key_pair" "bastion" {
  key_name   = "ec2-bastion"

  //paste ssh-keygen
  public_key = file("./files/ec2/bastion.pub")

  tags = {
    Name = "ec2_bastion_key"
    Environment = "common"
  }
}

resource "aws_key_pair" "app" {
  key_name   = "ec2-application"

  //paste ssh-keygen
  public_key = file("./files/ec2/application.pub")

  tags = {
    Name = "ec2_application_key"
    Environment = "common"
  }
}

output "key_pair" {
  value = {
    bastion_key_name = aws_key_pair.bastion.key_name
    app_key_name = aws_key_pair.app.key_name
  }
}
