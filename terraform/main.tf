resource "random_string" "postgres-password" {
  length  = 32
  upper   = true
  number  = true
  special = false
}

resource "aws_db_instance" "postgres-test-instance" {
  identifier              = "sb-upn-omop"
  name                    = "omopdata"
  allocated_storage       = 5
  storage_type            = "gp2"
  engine                  = "postgres"
  engine_version          = "12.5"
  instance_class          = "db.t2.micro"
  username                = "huskyrye"
  password                = random_string.postgres-password.result
  skip_final_snapshot     = true
  publicly_accessible     = true
  #vpc_security_group_ids   = ["${aws_security_group.postgress-sg.id}"]

  tags = {
    Name    = "postgres-test-instance"
    Project = "sb-upn"
  }
}

/*

https://techsparx.com/software-development/terraform/aws/rds/simple-deploy.html

resource "aws_vpc" "sb-upn-vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
}


resource "aws_subnet" "vpc_subnet" {
  vpc_id = aws_vpc.sb-upn-vpc.id
  cidr_block = "10.0.0.0/16"

  tags = {
    Name    = "postgres-test-instance"
    Project = "sb-upn"
  }
}

resource "aws_db_subnet_group" "subnet_group" {
  name        = "sb-upn-vpc-subnet-group"
  subnet_ids  = ["${aws_subnet.vpc_subnet.id}"]
}


resource "aws_security_group" "postgress-sg" {
  name = "postgress-sg"
  description = "RDS postgres servers (terraform-managed)"
  #vpc_id = aws_vpc.sb-upn-vpc.id

  # Only postgres in
  ingress {
    from_port = 5432
    to_port = 5432
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic.
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

*/