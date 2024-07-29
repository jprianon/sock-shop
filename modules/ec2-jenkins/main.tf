# Data Source aws_ami 
data "aws_ami" "amazon-linux-2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}
# Instance sock-shop on public subnet
resource "aws_instance" "ec2_jenkins" {
  count                       = var.number_instance
  ami                         = data.aws_ami.amazon-linux-2.id
  associate_public_ip_address = true
  instance_type               = var.instance_type
  key_name                    = var.key_name
  subnet_id                   = element(var.public_subnets_cidrs,count.index)
  vpc_security_group_ids      = [var.sg_pub_id]
  user_data                   = file("install_jenkins.sh")

  tags = {
    "Name" = "${var.namespace}"
  }
}

