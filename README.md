# Voucherfactory

## Description

## Business Case

1. Slides are available in [slides/README.md](slides/README.md)
2. Slides can be compiled to pdf with `make slides` from  the slides directory

## Getting Started

The system as a whole is set up using purely Amazon FaaS service offerings:
- Lambda
- Api Gateway
- Dynamo DB
The lambdas themselves are written in Python.

### Build and Install

1. Set up an S3 bucket for terraform state
2. Update Makefile with settings for AWS and bucket
3. run `make tfreset`
4. run `make build`
5. Review changes
6. run `make apply`

### Running locally

When running locally scripts expects a DynamoDB at port 8000.
A docker-compose file to set up a database is in the `/dynamoDB` folder.

Local runs are done with a very specific set of parameters and don't accept any arguments.
There are a few additional python scripts included to do some additional database tasks; however NoSQL Workbench is recommended https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/workbench.html

### API access

## Rest endpoints

There are three rest endpoints, they all accept json documents for their parameters, they are however not to the JSon:API specification; this should ammended before reaching "production". All fields in the API are mandatory.
- `CampaignFactory` is used to add Campaigns {campaign: string, vouchers: int, validity: int } 
- `VoucherFactory` registers a voucher  within a campaign for use {campaign: string, email: string}
- `VoucherOverseer` tries to "redeem" a voucher, checking validity and marking the voucher as used. {voucherid: string}

There are scripts including sample usage in [samples](samples)
Note that voucher ids are not returned by any of the scripts, only stored in the database and   will have to be retrieved from there.

Endpoints are publicly available at [https://eqlq08fsp9.execute-api.eu-west-1.amazonaws.com/default/] there is currently no authentication for  practical reasons, however they are under strict limitations (max 5 requests per second). 
