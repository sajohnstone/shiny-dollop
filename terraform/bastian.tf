
resource "aws_instance" "example" {
  ami             = data.aws_ami.ubuntu.id
  instance_type   = "t2.micro"
  security_groups = ["${aws_security_group.example.name}"]
  key_name        = "${aws_key_pair.generated_key.key_name}"

  provisioner "remote-exec" {
    inline = [
      "sudo apt update -y",
      "sudo apt-get install -y postgresql-client",
      "wget https://github.com/OHDSI/CommonDataModel/blob/master/PostgreSQL/OMOP%20CDM%20postgresql%20ddl.txt",
    ]

    connection {
      type        = "ssh"
      host        = self.public_dns
      private_key = "${tls_private_key.example.private_key_pem}"
      user        = "ubuntu"
      timeout     = "1m"
    }
  }

  tags = {
    Name    = "postgres-bastion"
    Project = "sb-upn"
  }
}

resource "tls_private_key" "example" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
  key_name   = "example_key_pair"
  public_key = "${tls_private_key.example.public_key_openssh}"

  tags = {
    Name    = "postgres-bastion-kp"
    Project = "sb-upn"
  }
}

resource "aws_security_group" "example" {
  name        = "grant ssh"
  description = "grant ssh"

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
    Name    = "postgres-bastion-sg"
    Project = "sb-upn"
  }
}



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