resource "aws_instance" "public-server" {

  #count = length(aws_subnet.public-subnet)
  count = var.environment == "prod" ? 3 : 1
  #ami                         = "ami-0b6d9d3d33ba97d99" 
  ami                         = lookup(var.amis, var.aws_region)
  instance_type               = "t3.micro"
  key_name                    = "new"
  subnet_id                   = aws_subnet.public-subnet[count.index].id
  vpc_security_group_ids      = [aws_security_group.allow_all.id]
  associate_public_ip_address = true
  tags = {
    Name       = "public-server-${count.index + 1}"
    Env        = "Prod"
    Owner      = "sudheer"
    CostCenter = "ABCD"
  }


}