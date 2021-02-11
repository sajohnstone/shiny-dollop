data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

# ssh key
resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = file("./../my_secrey_key.pub")
}

# Configuration for your bastion EC2 instance
resource "aws_instance" "bastion" {
  ami = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  count = var.bastion_enabled ? 1 : 0

  key_name = aws_key_pair.deployer.key_name

  #subnet_id = aws_subnet.subnet[0].id

  #vpc_security_group_ids = [aws_security_group.hn_bastion_sg.id, aws_default_security_group.default.id]

  associate_public_ip_address = true


  #vpc_security_group_ids = [
  #  aws_security_group.postgres-bastion-sg.id
  #]

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("./../my_secrey_key")
    host        = self.public_ip
    timeout = "2m"
  }

  ebs_block_device {
    device_name = "/dev/sda1"
    volume_type = "gp2"
    volume_size = 8
  }

  tags = {
    Name    = "postgres-bastion"
    Project = "sb-upn"
  }

  #provisioner "file" {
  #  source      = "file-test.txt"
  #  destination = "/Windows/Temp/file-test.txt"
  #}

  #provisioner "remote-exec" {
  #  inline = [
  #    "sudo apt update -y",
  #    "sudo apt-get install -y postgresql-client",
  #    "wget https://github.com/OHDSI/CommonDataModel/blob/master/PostgreSQL/OMOP%20CDM%20postgresql%20ddl.txt",
  #  ]
  #}
}


resource "aws_security_group" "postgres-bastion-sg" {
  name        = "postgres-bastion-sg"
  description = "Allow SSH inbound traffic"

  tags = {
    Name    = "postgres-bastion-sg"
    Project = "sb-upn"
  }
}

resource "aws_security_group_rule" "allow_ssh_ingress" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"] #var.myip - lock it down
  security_group_id = aws_security_group.postgres-bastion-sg.id
}

resource "aws_network_interface_sg_attachment" "sg_attachment" {
  security_group_id    = aws_security_group.postgres-bastion-sg.id
  network_interface_id = aws_instance.bastion[0].primary_network_interface_id
}

# We want to output the public_dns name of the bastion host when it spins up
output "bastion-public-dns" {
  value = var.bastion_enabled ? aws_instance.bastion[0].public_dns : "No-bastion"
}