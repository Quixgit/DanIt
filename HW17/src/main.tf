provider "aws" {
  region = "eu-north-1"
}

#  Creat VPC
resource "aws_vpc" "my_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "my_vpc"
  }
}

# Creat public subnet
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "eu-north-1a"

  tags = {
    Name = "public_subnet"
  }
}

# Creat private sunet
resource "aws_subnet" "private_subnet" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "eu-north-1a"

  tags = {
    Name = "private_subnet"
  }
}

# Creat gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "internet_gateway"
  }
}

# Creat route
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "public_route_table"
  }
}

resource "aws_route" "public_route" {
  route_table_id         = aws_route_table.public_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "public_subnet_association" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_route_table.id
}

# Creat NAT
resource "aws_eip" "nat_eip" {
  domain = "vpc"
}

resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnet.id

  tags = {
    Name = "nat_gateway"
  }

  depends_on = [aws_internet_gateway.igw]
}

# Route private ssubnet NAT-gateway
resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "private_route_table"
  }
}

resource "aws_route" "private_route" {
  route_table_id         = aws_route_table.private_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gw.id
}

resource "aws_route_table_association" "private_subnet_association" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_route_table.id
}

# Security Groups
# Security Group for ssh
resource "aws_security_group" "public_sg" {
  vpc_id = aws_vpc.my_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
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
    Name = "public_sg"
  }
}

# Security Group private instance
resource "aws_security_group" "private_sg" {
  vpc_id = aws_vpc.my_vpc.id

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.public_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # was error
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "private_sg"
  }
}

# Creat EC2
# Public instance
resource "aws_instance" "public_instance" {
  ami                    = "ami-089146c5626baa6bf" 
  instance_type          = "t3.nano"
  subnet_id              = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.public_sg.id]
  key_name               = "my_ssh_key"

  tags = {
    Name = "public_instance"
  }
}

# Private instance
resource "aws_instance" "private_instance" {
  ami                    = "ami-089146c5626baa6bf"
  instance_type          = "t3.nano"
  subnet_id              = aws_subnet.private_subnet.id
  vpc_security_group_ids = [aws_security_group.private_sg.id]
  key_name               = "my_ssh_key"

  tags = {
    Name = "private_instance"
  }
}