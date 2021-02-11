# AWS Glue PoC

The purpose of this is to show that it's possible to use AWS Glue to transform data from [MIMIC data format](https://mit-lcp.github.io/mimic-schema-spy/relationships.html) into [OMOP standard](https://github.com/OHDSI/CommonDataModel/tree/master/PostgreSQL).  For the purpose of this PoC the plan is simply to transfer data between patients and person.

## Getting started

For this you will need and AWS account with access to the AWS cli.  Terraform for running the terraform scripts and psql for the SQL scripts.
Running the Terraform scripts will do the following:-

- Provision new RDS instance using the Postgres Schema
- Import and create the schema
- Provision new Glue instance

### Accessing the bastian

You will need to create a bastian.tfvars file that looks something like this:-

```bash
# Set this to `true` and do a `terraform apply` to spin up a bastion host
# and when you are done, set it to `false` and do another `terraform apply`
bastion_enabled = true
# My SSH keyname (without the .pem extension)
ssh_key_name = "sb-upn-stu-aws"
# The IP of my computer. Do a `curl -sq icanhazip.com` to get it
myip = ["195.213.74.49/32"]
```

To provision you need to :-

```bash
terraform -chdir=terraform/ init
terraform -chdir=terraform/ apply
```

## Mapping

```bash
             ╔  day_of_birth
   dob     ══╣  month_of_birth
             ╚  year_of_birth
```

## Improvements

Things we would need to improve for the prod version are:-

- Put RDS into a VPC
- Scale the db.t2.micro to something more suitable
- The SQL scripts are provisioned locally ideally this should be on a bastion for security
- No backups have been provisioned
- Enhanced monitoring is suggested for prodcution instances

## Credits

The SQL scripts I'm provisining are from here git clone <https://github.com/OHDSI/CommonDataModel.git>.  For convienece I have included them in this project be please download them from source.
