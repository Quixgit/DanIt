# 1. Создание S3 Bucket для хранения файлов состояния Terraform
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
  bucket = "quix-s3-bucket-unique-123456"
}

terraform {
  backend "s3" {
    bucket = "quix-s3-bucket-unique-123456"
    key    = "terraform/state" 
    region = "eu-north-1" 
    encrypt = true 
  }
}

terraform {
  backend "s3" {
    bucket         = "quix-s3-bucket-12345678"
    key            = "terraform/state.tfstate"
    region         = "eu-north-1"
    encrypt        = true
  }
}

# 2. Создание VPC и подсетей
resource "aws_vpc" "quix_vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.quix_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true  # ВАЖНО: автоматически назначать публичный IP
}

resource "aws_subnet" "private" {
  vpc_id     = aws_vpc.quix_vpc.id
  cidr_block = "10.0.2.0/24"
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.quix_vpc.id
}

# 3. Создание маршрута для публичной подсети
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

# 4. Security Group с доступом по SSH
resource "aws_security_group" "jenks_sg" {
  vpc_id = aws_vpc.quix_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Открыто для всех
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

# 5. Создание Elastic IP для NAT Gateway
resource "aws_eip" "nat" {
  domain = "vpc"
}

# 6. Создание NAT Gateway в публичной подсети
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public.id
}

# 7. Создание маршрутной таблицы для частной подсети
resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.quix_vpc.id
}

# 8. Маршрут для выхода в интернет для частной подсети через NAT Gateway
resource "aws_route" "private_nat_route" {
  route_table_id         = aws_route_table.private_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat.id  # Направляем через NAT Gateway
}

# 9. Ассоциация маршрутной таблицы с частной подсетью
resource "aws_route_table_association" "private_association" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private_route_table.id
}

# 10. EC2 инстанс Jenkins Master в публичной подсети
resource "aws_instance" "inst_jenks_master" {
  ami                    = "ami-09a9858973b288bdd"
  instance_type          = var.instance_type_master
  subnet_id              = aws_subnet.public.id
  associate_public_ip_address = true  # Гарантированно получает публичный IP
  key_name               = var.ssh_key_name
  vpc_security_group_ids = [aws_security_group.jenks_sg.id]

  user_data = <<-EOF
                #!/bin/bash
                echo "Hello from Jenkins Master" > /var/log/user-data.log
                EOF

  tags = {
    Name = "Jenkins_Master"
  }
}

# 11. EC2 инстанс Jenkins Worker в частной подсети
resource "aws_instance" "inst_jenks_worker" {
  ami                    = "ami-09a9858973b288bdd"
  instance_type          = var.instance_type_worker
  subnet_id              = aws_subnet.private.id
  key_name               = var.ssh_key_name
  vpc_security_group_ids = [aws_security_group.jenks_sg.id]

  user_data = <<-EOF
                #!/bin/bash
                echo "Hello from Jenkins Worker" > /var/log/user-data.log
                EOF

  tags = {
    Name = "Jenkins_Worker"
  }
}

# 12. Генерация inventory для Ansible
resource "template_file" "ansible_inventory" {
  template = <<-EOT
    # inventory.ini

    [jenkins_master]
    ${aws_instance.inst_jenks_master.public_ip} ansible_ssh_user=ubuntu ansible_ssh_private_key_file=${var.ssh_key_name}

    [jenkins_worker]
    ${aws_instance.inst_jenks_worker.private_ip} ansible_ssh_user=ubuntu ansible_ssh_private_key_file=${var.ssh_key_name}

    [all:vars]
    ansible_python_interpreter=/usr/bin/python3
  EOT
}

# 13. Сохранение инвентори в файл
resource "local_file" "ansible_inventory_file" {
  content  = template_file.ansible_inventory.rendered
  filename = "${path.module}/inventory.ini"
}
