resource "random_string" "postgres-password" {
  length  = 32
  upper   = true
  number  = true
  special = false
}

resource "aws_db_instance" "default" {
  identifier           = "sb-upn-omop"
  name                 = "omopdata"
  allocated_storage    = 5
  storage_type         = "gp2"
  engine               = "postgres"
  engine_version       = "12.5"
  instance_class       = "db.t2.micro"
  username             = "huskyrye"
  password             = random_string.postgres-password.result
  skip_final_snapshot  = true
  publicly_accessible  = false
  
  tags = {
    Name    = "rds-postgres-test-instance"
    Project = "sb-upn"
  }
/*
  provisioner "local-exec" {
    command = "mysql --host=${self.address} --port=${self.port} --user=${self.username} --password=${self.password} < ./schema.sql"
  }*/
}

/*
#Apply scheme by using bastion host
resource "aws_db_instance" "default_bastion" {
  identifier           = module.config.database["db_inst_name"]
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t3.micro"
  name                 = "${module.config.database["db_name_prefix"]}${terraform.workspace}"
  username             = module.config.database["db_username"]
  password             = module.config.database["db_password"]
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true


  provisioner "file" {
    connection {
      user        = "ec2-user"
      host        = "bastion.example.com"
      private_key = file("~/.ssh/ec2_cert.pem")
    }

    source      = "./schema.sql"
    destination = "~"
  }

  provisioner "remote-exec" {
    connection {
      user        = "ec2-user"
      host        = "bastion.example.com"
      private_key = file("~/.ssh/ec2_cert.pem")
    }

    command = "mysql --host=${self.address} --port=${self.port} --user=${self.username} --password=${self.password} < ~/schema.sql"
  }
  }

  */

