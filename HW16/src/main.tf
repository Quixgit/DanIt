provider "aws" {
    region = "eu-north-1"
}


resource "aws_security_group" "sg_test_instance"{
  name = "sg_test_instance"

  ingress{
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
  }
  egress{
    from_port = 0
    to_port = 0
    protocol = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
  }
}

# Create instance
resource "aws_instance" "danit_instance_16" {
  ami = "ami-089146c5626baa6bf"
  instance_type = "t3.nano"
  key_name = "my_ssh_key"
  vpc_security_group_ids = [ aws_security_group.sg_test_instance.id ]
  tags = {
    Name = "danit_instance_16"
  }
}
