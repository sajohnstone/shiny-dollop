# AWS Glue PoC

The purpose of this is to show that it's possible to use AWS Glue to transform data from (https://mit-lcp.github.io/mimic-schema-spy/relationships.html)[MIMIC data format] into (https://github.com/OHDSI/CommonDataModel/tree/master/PostgreSQL)[OMOP standard].  For the purpose of this PoC the plan is simply to transfer data between patients and person.

## Getting started

For this you will need and AWS account with access to the AWS cli.  Running the terraform scripts will do the following:-

- Provision new RDS instance using the Postgres Schema
- Import and create the schema
- Provision new Glue instance

## Mapping 


             ╔  day_of_birth
   dob     ══╣  month_of_birth
             ╚  year_of_birth

