# AWS Glue PoC

The purpose of this is to show that it's possible to use AWS Glue to transform data from [MIMIC data format](https://mit-lcp.github.io/mimic-schema-spy/relationships.html) into [OMOP standard](https://github.com/OHDSI/CommonDataModel/tree/master/PostgreSQL).  For the purpose of this PoC the plan is simply to transfer data between patients and person.

## Getting started

For this you will need and AWS account with access to the AWS cli.  Terraform for running the terraform scripts and psql for the SQL scripts.
Running the Terraform scripts will do the following:-

- Provision new RDS instance using the Postgres Schema
- Import and create the schema
- Provision new Glue instance

### Accessing the bastian

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
- Lock the bastion so can only be access from your IP

## Credits

The SQL scripts I'm provisining are from here git clone <https://github.com/OHDSI/CommonDataModel.git>.  For convienece I have included them in this project be please download them from source.
