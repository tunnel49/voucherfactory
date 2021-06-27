import boto3
from pprint import pprint
from botocore.exceptions import ClientError
from time import time

class CampaignExistsError(Exception):
    pass

def lambda_handler(event, context):
    dynamodb = boto3.resource('dynamodb',)
    try:
        campaign = event['campaign']
        vouchers = int(event['vouchers'])
        validity = int(event['validity'])
    except (ValueError,KeyError):
        raise Exception('400: Invalid input')
    except Exception as e:
        pprint(e)
        raise Exception('400: Unexpected error')
    try:
        campaignfactory(campaign, vouchers, validity, dynamodb)
    except CampaignExistsError:
        raise Exception('400: Campaign already exists')
    except Exception as e:
        pprint(e)
        raise Exception('400: Unexpected error')
    return "Campaign created successfully"
    
def campaignfactory(campaign, vouchers, validity, dynamodb=None):
    if not dynamodb:
        dynamodb = boto3.resource('dynamodb', 
                                  aws_access_key_id="anything",
                                  aws_secret_access_key="anything",
                                  region_name="eu-west-1",
                                  endpoint_url="http://localhost:8000")
    register_campaign(campaign, vouchers, validity, dynamodb)
#    create_campaign_table(campaign, dynamodb)

def register_campaign(campaign, vouchers, validity, dynamodb):
    epoch = int(time())
    expiration = epoch + validity

    table = dynamodb.Table('Campaigns')
    try:
        response = table.put_item(
            Item={
                'Campaign': campaign,
                'CampaignId': 1,
                'Vouchers': vouchers,
                'Available': vouchers,
                'Creation': epoch,
                'Expiration': expiration
            },
            ConditionExpression="attribute_not_exists(Campaign)"
        )
    except ClientError as e:
        if e.response['Error']['Code'] == 'ConditionalCheckFailedException':
            raise CampaignExistsError
        else:
            raise 
    except:
        raise 
    return response


def create_campaign_table(campaign, dynamodb):
    if not dynamodb:
        dynamodb = boto3.resource('dynamodb', 
                                  aws_access_key_id="anything",
                                  aws_secret_access_key="anything",
                                  region_name="eu-west-1",
                                  endpoint_url="http://localhost:8000")

    table = dynamodb.create_table(
        TableName=campaign,
        KeySchema=[
            {
                'AttributeName': 'Voucher',
                'KeyType': 'HASH'
            }
        ],
        AttributeDefinitions=[
            {
                'AttributeName': 'Voucher',
                'AttributeType': 'N'
            },
        ],
        ProvisionedThroughput={
            'ReadCapacityUnits': 10,
            'WriteCapacityUnits': 10
        }
    )
    return table

if __name__ == '__main__':
    response = campaignfactory("TestCampaign",10,600)
    print("Create Campaign Successfull")
    pprint(response, sort_dicts=False)
