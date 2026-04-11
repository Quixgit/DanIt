resource "aws_s3_bucket" "terraform_state" {
  bucket = "quix-s3-bucket-12345678"
}

resource "aws_s3_bucket_versioning" "terraform_state_versioning" {
  bucket = aws_s3_bucket.terraform_state.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "terraform_state_public_access" {
  bucket = aws_s3_bucket.terraform_state.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

}

resource "aws_s3_bucket" "terraform_state" {
  bucket = "quix-s3-bucket-unique-12345678"
}

terraform {
  backend "s3" {
    bucket         = "quix-s3-bucket-12345678"
    key            = "terraform/state.tfstate"
    region         = "eu-north-1"
    encrypt        = true
  }
}

# Ð¡Ð¾Ð·Ð´Ð°Ð½Ð¸Ðµ VPC Ð¸ Ð¿Ð¾Ð´ÑÐµÑÐµÐ¹
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

# ÐÐ°ÑÑÑÑÑ Ð´Ð»Ñ Ð¿ÑÐ±Ð»Ð¸ÑÐ½Ð¾Ð¹ Ð¿Ð¾Ð´ÑÐµÑÐ¸
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.quix_vpc.id
}

resource "aws_route" "default_route" {
  route_table_id         = aws_route_table.public_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.gw.id
}

resource "aws_route_table_association" "public_association" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public_route_table.id
}

# Security Group Ñ Ð´Ð¾ÑÑÑÐ¿Ð¾Ð¼ Ð¿Ð¾ SSH
resource "aws_security_group" "jenks_sg" {
  vpc_id = aws_vpc.quix_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Ð¡Ð¾Ð·Ð´Ð°Ð½Ð¸Ðµ Elastic IP Ð´Ð»Ñ NAT Gateway
resource "aws_eip" "nat" {
  domain = "vpc"
}

# Ð¡Ð¾Ð·Ð´Ð°Ð½Ð¸Ðµ NAT Gateway Ð² Ð¿ÑÐ±Ð»Ð¸ÑÐ½Ð¾Ð¹ Ð¿Ð¾Ð´ÑÐµÑÐ¸
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public.id
}

# Ð¡Ð¾Ð·Ð´Ð°Ð½Ð¸Ðµ Ð¼Ð°ÑÑÑÑÑÐ½Ð¾Ð¹ ÑÐ°Ð±Ð»Ð¸ÑÑ Ð´Ð»Ñ ÑÐ°ÑÑÐ½Ð¾Ð¹ Ð¿Ð¾Ð´ÑÐµÑÐ¸
resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.quix_vpc.id
}

# ÐÐ°ÑÑÑÑÑ Ð´Ð»Ñ Ð²ÑÑÐ¾Ð´Ð° Ð² Ð¸Ð½ÑÐµÑÐ½ÐµÑ Ð´Ð»Ñ ÑÐ°ÑÑÐ½Ð¾Ð¹ Ð¿Ð¾Ð´ÑÐµÑÐ¸ ÑÐµÑÐµÐ· NAT Gateway
resource "aws_route" "private_nat_route" {
  route_table_id         = aws_route_table.private_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat.id  
}

# ÐÑÑÐ¾ÑÐ¸Ð°ÑÐ¸Ñ
resource "aws_route_table_association" "private_association" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private_route_table.id
}

# EC2 Ð¸Ð½ÑÑÐ°Ð½Ñ Jenkins Master Ð² Ð¿ÑÐ±Ð»Ð¸ÑÐ½Ð¾Ð¹ Ð¿Ð¾Ð´ÑÐµÑÐ¸
resource "aws_instance" "inst_jenks_master" {
  ami                    = "ami-09a9858973b288bdd"
  instance_type          = var.instance_type_master
  subnet_id              = aws_subnet.public.id
  associate_public_ip_address = true  
  key_name               = var.ssh_key_name
  vpc_security_group_ids = [aws_security_group.jenks_sg.id]

  user_data = <<-EOF
                #!/bin/bash
                echo "Hello Quix" > /var/log/user-data.log
                EOF

  tags = {
    Name = "Jenkins_Master"
  }
}

# EC2 Ð¿ÑÐ¸Ð²Ð°Ñtest
resource "aws_instance" "inst_jenks_worker" {
  ami                    = "ami-09a9858973b288bdd"
  instance_type          = var.instance_type_worker
  subnet_id              = aws_subnet.private.id
  key_name               = var.ssh_key_name
  vpc_security_group_ids = [aws_security_group.jenks_sg.id]

  user_data = <<-EOF
                #!/bin/bash
                echo "Hello 2" > /var/log/user-data.log
                EOF

  tags = {
    Name = "Jenkins_Worker"
  }
}

resource "template_file" "ansible_inventory" {
  template = <<-EOT
    # inventory.ini

    [inst_jenks_master]
    ${aws_instance.inst_jenks_master.public_ip} ansible_ssh_user=ubuntu ansible_ssh_private_key_file=${var.ssh_key_name}
  EOT
}

resource "local_file" "ansible_inventory_file" {
  content  = template_file.ansible_inventory.rendered
  filename = "${path.module}/inventory.ini"
}
