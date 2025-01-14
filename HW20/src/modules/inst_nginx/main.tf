resource "aws_security_group" "nginx_sg" {
  name_prefix = "nginx-sg-"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"  
    cidr_blocks = ["0.0.0.0/0"]
  }


  ingress {
    from_port   = var.list_of_open_ports[0]
    to_port     = var.list_of_open_ports[length(var.list_of_open_ports) - 1]  
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

resource "aws_instance" "nginx_ec2" {
  ami                    = "ami-075449515af5df0d1"
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.nginx_sg.id] 
  associate_public_ip_address = true

  tags = {
    Name = "inst_nginx"
  }

  user_data = <<-EOF
              #!/bin/bash
              apt-get update
              apt-get install -y nginx
              systemctl enable nginx
              systemctl start nginx
              EOF

}