provider "aws" {
  region = "eu-north-1" # Замените на ваш регион
}

# VPC
resource "aws_vpc" "quix_vpc" {
  cidr_block       = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = "quix-vpc"
  }
}

# Public sub network
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.quix_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "eu-north-1a"
  tags = {
    Name = "PublicSubnet"
  }
}

# Private sub network
resource "aws_subnet" "private_subnet" {
  vpc_id            = aws_vpc.quix_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "eu-north-1a"
  tags = {
    Name = "PrivateSubnet"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.quix_vpc.id
  tags = {
    Name = "MyInternetGateway"
  }
}

# Table public subnet
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.quix_vpc.id
  tags = {
    Name = "PublicRouteTable"
  }
}

resource "aws_route" "default_route" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

# Sg public
resource "aws_security_group" "public_sg" {
  vpc_id = aws_vpc.quix_vpc.id
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
    Name = "PublicSG"
  }
}

# Sg private
resource "aws_security_group" "private_sg" {
  vpc_id = aws_vpc.quix_vpc.id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    security_groups = [aws_security_group.public_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "PrivateSG"
  }
}

# EC2 public subnet
resource "aws_instance" "public_instance" {
  ami           = "ami-089146c5626baa6bf" 
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.public_subnet.id
  security_groups = [aws_security_group.public_sg.id]
  tags = {
    Name = "PublicInstance"
  }
}

# EC2 private subnet
resource "aws_instance" "private_instance" {
  ami           = "ami-089146c5626baa6bf" 
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.private_subnet.id
  security_groups = [aws_security_group.private_sg.id]
  tags = {
    Name = "PrivateInstance"
  }
}