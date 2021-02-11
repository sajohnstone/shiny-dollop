resource "random_string" "postgres-password" {
  length  = 32
  upper   = true
  number  = true
  special = false
}

resource "aws_db_instance" "postgres-test-instance" {
  identifier          = "sb-upn-omop"
  name                = "omopdata"
  allocated_storage   = 5
  storage_type        = "gp2"
  engine              = "postgres"
  engine_version      = "12.5"
  instance_class      = "db.t2.micro"
  username            = "huskyrye"
  password            = random_string.postgres-password.result
  skip_final_snapshot = true
  publicly_accessible = true

  tags = {
    Name    = "postgres-test-instance"
    Project = "sb-upn"
  }
}