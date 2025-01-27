resource "aws_s3_bucket" "terraform_state" {
  bucket = "quix_bucket_state"
  acl    = "private"
}

resource "aws_vpc" "quix_vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.quix_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
}

resource "aws_subnet" "private" {
  vpc_id     = aws_vpc.quix_vpc.id
  cidr_block = "10.0.2.0/24"
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.quix_vpc.id
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.net.id
  subnet_id     = aws_subnet.public.id
}

resource "aws_security_group" "jenks_sg" {
  vpc_id = aws_vpc.quix_vpc
  ingress {
    from_port  = 22
    to_port    = 22
    protocol   = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port  = 8080
    to_port    = 8080
    protocol   = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "inst_jenks" {
  ami = ""
  instance_type = t3.micro
  subnet_id = aws_subnet.public.id
  key_name = var.ssh_name
  tags = {
    Name = "Jenks_master"
  }
}

resource "aws_instance" "inst_worker" {
  ami = ""
  instance_type = t3.micro
  subnet_id = aws_subnet.private.id
  key_name = var.ssh_name
  tags = {
    Name = "Jenks_master"
  }
}

