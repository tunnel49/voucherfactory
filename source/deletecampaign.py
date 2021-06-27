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
    except (ValueError,KeyError):
        raise Exception('400: Invalid input')
    except Exception as e:
        pprint(e)
        raise Exception('500: Unexpected error')
    try:
        delete_campaign(campaign, dynamodb)
    except Exception as e:
        pprint(e)
        raise Exception('500: Unexpected error')
    return "Campaign deleted successfully"
    
def delete_campaign(campaign, dynamodb=None):
    if not dynamodb:
        dynamodb = boto3.resource('dynamodb', 
                                  aws_access_key_id="anything",
                                  aws_secret_access_key="anything",
                                  region_name="eu-west-1",
                                  endpoint_url="http://localhost:8000")
    remove_campaign(campaign, dynamodb)
    delete_campaign_table(campaign, dynamodb)

def remove_campaign(campaign, dynamodb):
    table = dynamodb.Table('Campaigns')
    response = table.delete_item(
        Key={
            'Campaign': campaign,
        },
    )
    return response


def delete_campaign_table(campaign, dynamodb):
    if not dynamodb:
        dynamodb = boto3.resource('dynamodb', 
                                  aws_access_key_id="anything",
                                  aws_secret_access_key="anything",
                                  region_name="eu-west-1",
                                  endpoint_url="http://localhost:8000")
    table = dynamodb.Table(campaign)
    table.delete()

if __name__ == '__main__':
    response = delete_campaign("TestCampaign",10,600)
    print("Delete Campaign Successfull")
    pprint(response, sort_dicts=False)
