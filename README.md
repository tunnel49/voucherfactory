# Voucherfactory

## Description

## Getting Started

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


### Access API using aws
aws lambda invoke --region=us-east-1 --function-name=ServerlessExample output.txt
