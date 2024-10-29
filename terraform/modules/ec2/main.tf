# Data Source aws_ami 
data "aws_ami" "amazon-linux-2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}
# Bastion public
resource "aws_instance" "ec2_public" {
  count                       = length(var.public_subnets_cidrs)
  ami                         = data.aws_ami.amazon-linux-2.id
  associate_public_ip_address = true
  instance_type               = var.instance_type
  key_name                    = var.key_name
  subnet_id                   = element(var.public_subnets_cidrs,count.index)
  vpc_security_group_ids      = [var.sg_pub_id]
  user_data                   = file("install_wordpress.sh")

  tags = {
    "Name" = "${var.namespace}-Bastion"
  }
}

# Wordpress private
resource "aws_instance" "ec2_private" {
  count                       = length(var.private_subnets_cidrs)
  ami                         = data.aws_ami.amazon-linux-2.id
  associate_public_ip_address = false
  instance_type               = var.instance_type
  key_name                    = var.key_name
  subnet_id                   = element(var.private_subnets_cidrs,count.index)
  vpc_security_group_ids      = [var.sg_priv_id]

  tags = {
    "Name" = "${var.namespace}-Wordpress"
  }
}

# Create an autoscaling group 
resource "aws_launch_configuration" "wordpress_autoscaling_configuration" {
  image_id      = data.aws_ami.amazon-linux-2.id
  name          = "wordpress-autoscaling-config"
  instance_type = var.instance_type
}

# Launch configuration for wordpress
resource "aws_autoscaling_group" "wordpress-autoscaling" {
  name                 = "wordpress-autoscaling-group"
  max_size             = 1
  min_size             = 1
  desired_capacity     = 1
  launch_configuration = aws_launch_configuration.wordpress_autoscaling_configuration.id
  vpc_zone_identifier  = var.private_subnets_cidrs
}