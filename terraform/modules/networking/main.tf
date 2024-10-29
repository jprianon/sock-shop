resource "aws_vpc" "vpc" {
  cidr_block = var.vpc

  tags = {
    Name = "JP-VPC"
  }
}

# Public subnets
resource "aws_subnet" "public_subnets" {
  count                   = length(var.public_subnets_cidrs)
  vpc_id                  = aws_vpc.vpc.id 
  cidr_block              = var.public_subnets_cidrs[count.index]
  availability_zone       = var.available_zones[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "JP-Public-Subnet-${var.available_zones[count.index]}"
  }
}

# Private subnets
resource "aws_subnet" "private_subnets" {
  count             = length(var.private_subnets_cidrs)
  vpc_id            = aws_vpc.vpc.id 
  cidr_block        = var.private_subnets_cidrs[count.index]
  availability_zone = var.available_zones[count.index]

  tags = {
    Name = "JP-Private-Subnet-${var.available_zones[count.index]}"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "JP-Internet-Gateway"
  }
}

# Public Route Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "JP-Public-Route-Table"
  }
}

# Public Route Table Associations
resource "aws_route_table_association" "public_association" {
  count          = length(var.public_subnets_cidrs)
  subnet_id      = aws_subnet.public_subnets[count.index].id
  route_table_id = aws_route_table.public.id
}

# NAT Gateway in a single public subnet
resource "aws_eip" "nat_eip" {

  tags = {
    Name = "JP-NAT-EIP"
  }
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnets[0].id  # Only one NAT Gateway

  tags = {
    Name = "JP-NAT-Gateway"
  }
}

# Private Route Table
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name = "JP-Private-Route-Table"
  }
}

# Private Route Table Associations
resource "aws_route_table_association" "private_association" {
  count          = length(var.private_subnets_cidrs)
  subnet_id      = aws_subnet.private_subnets[count.index].id
  route_table_id = aws_route_table.private.id
}

# Security Groups (Public and Private)
resource "aws_security_group" "allow_ssh_pub" {
  name        = "${var.namespace}-allow-ssh-pub"
  description = "Allow SSH and HTTP from the Internet"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
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
    Name = "${var.namespace}-allow-ssh-pub"
  }
}

resource "aws_security_group" "allow_ssh_priv" {
  name        = "${var.namespace}-allow-ssh-priv"
  description = "Allow SSH from VPC internal clients"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }
  ingress {
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
    Name = "${var.namespace}-allow-ssh-priv"
  }
}
