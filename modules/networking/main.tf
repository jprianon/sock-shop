resource "aws_vpc" "vpc" {
  cidr_block = var.vpc

  tags = {
    Name = "${var.vpc_name}"
  }
}

#public subnets
resource "aws_subnet" "public_subnets" {
  count                   = length(var.public_subnets_cidrs)
  vpc_id                  = aws_vpc.vpc.id 
  cidr_block              = element(var.public_subnets_cidrs, count.index)
  availability_zone       = element(var.available_zones, count.index)
  map_public_ip_on_launch = true
  depends_on              = [aws_vpc.vpc]
  tags = {
    Name = "${var.subnet_public_name}_${element(var.available_zones, count.index)}"
  }
}

#private subnets
resource "aws_subnet" "private_subnets" {
  count             = length(var.private_subnets_cidrs)
  vpc_id            = aws_vpc.vpc.id 
  cidr_block        = element(var.private_subnets_cidrs, count.index)
  availability_zone = element(var.available_zones, count.index)
  tags = {
    Name = "${var.subnet_public_name}_${element(var.available_zones, count.index)}"
  }
}

# create route for the main vpc and attach Internet Gateway 
resource "aws_route_table" "rtb_public" {
  vpc_id = aws_vpc.vpc.id
  count  = length(var.public_subnets_cidrs)
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw-public_subnets.id
  }
  route {
    cidr_block     = element(aws_subnet.public_subnets[*].cidr_block, count.index)
    nat_gateway_id = element(aws_nat_gateway.nat-gateway[*].id, count.index)
  }
  tags = {
    Name = "${var.rtb_public_name}_${element(var.available_zones, count.index)}"
  }

}
# Create route table association for public subnets to the the nat gateway
resource "aws_route_table_association" "rtb_public_subnets_association" {
  count          = length(var.public_subnets_cidrs)
  subnet_id      = element(aws_subnet.public_subnets[*].id, count.index)
  route_table_id = element(aws_route_table.rtb_public[*].id, count.index)
  depends_on     = [aws_internet_gateway.igw-public_subnets]
}

# Create the internet gateway for the public subnets
resource "aws_internet_gateway" "igw-public_subnets" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.public_subnets_igw_name}"
  }
}

# Create the nat gateway for the public subnets with elastic ip
resource "aws_nat_gateway" "nat-gateway" {
  count         = length(var.public_subnets_cidrs)
  allocation_id = element(aws_eip.elastic_ip[*].id, count.index)
  subnet_id     = element(aws_subnet.public_subnets[*].id, count.index)

  tags = {
    Name = "${var.nat_gw_name}_${element(var.available_zones, count.index)}"
  }
}

# Create a database subnet group 
#resource "aws_db_subnet_group" "my_private_subnet_group" {
#  name       = var.private_db_subnet_group #"${private_db_subnet_group}"
#  subnet_ids = [for subnet in aws_subnet.private_subnets : subnet.id] # Assuming you have one private subnet
#}

# Create an elastic ip from each public subnet ip
resource "aws_eip" "elastic_ip" {
  count                     = length(var.public_subnets_cidrs)
  associate_with_private_ip = element(var.public_subnets_cidrs, count.index)
  tags = {
    Name = "${var.elastic_ip_name}_${element(var.available_zones, count.index)}"
  }
}

# SG pour autoriser les connexions SSH + HTTP depuis n'importe quel hôte
resource "aws_security_group" "allow_ssh_pub" {
  name        = "${var.namespace}-allow_ssh"
  description = "Autoriser le trafic entrant SSH et HTTP"
  vpc_id      = aws_vpc.vpc.id 

  ingress {
    description = "SSH depuis Internet"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "HTTP depuis Internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${var.namespace}-allow_ssh_pub"
  }
}

#SG pour autoriser uniquement les connexions SSH + 80 à partir de sous-réseaux publics VPC
resource "aws_security_group" "allow_ssh_priv" {
  name        = "${var.namespace}-allow_ssh_priv"
  description = "Autoriser le trafic entrant SSH"
  vpc_id      = aws_vpc.vpc.id 

  ingress {
    description = "SSH uniquement a partir de clients VPC internes"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }
  ingress {
    description = "HTTP uniquement a partir de clients VPC internes"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.namespace}-allow_ssh_priv"
  }
}