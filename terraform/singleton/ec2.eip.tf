//bastion ip
resource "aws_eip" "bastion" {
  vpc      = true
  instance = aws_instance.bastion.id

  tags = {
    Name = "bastion-eip"
    Environment = "common"
  }
}