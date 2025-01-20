provider "aws"{
 region = "eu-north-1"
}

resource "aws_instance" "inst_ec2"{
 count         = 2
 ami           = "ami-09a9858973b288bdd"
 instance_type = "t3.micro"
 key_name      = "my_ssh_key"
 tags = {
  Name = "inst_ec2_${count.index + 1}"
}
}

output "inventory"{
 value = aws_instance.inst_ec2[*].public_ip   
}

data "template_file" "inventory"{
 template = file("inventory.tpl")
 vars = {
  public_ips = join("\n", aws_instance.inst_ec2[*].public_ip)
 }
}

resource "local_file" "inventory"{
 content  = data.template_file.inventory.rendered
 filename = "inventory"
}



