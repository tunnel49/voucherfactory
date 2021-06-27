import boto3
import secrets
import base64
import struct
from botocore.exceptions import ClientError
from decimal import Decimal
from pprint import pprint
from time import time

class VoucherDepletionError(Exception):
    pass
class CampaignExpiredError(Exception):
    pass

def lambda_handler(event, context):
    dynamodb = boto3.resource('dynamodb',)
    try:
        campaign = event['campaign']
        email   = event['email']
    except (ValueError, KeyError):
        raise Exception('400: Invalid input')
    except Exception as e:
        pprint(e)
        raise Exception('400: Unexpected error')
    try:
        voucherfactory(campaign, email, dynamodb) 
    except (VoucherDepletionError, CampaignExpiredError):
        raise Exception('400: No vouchers available')
    except Exception as e:
        pprint(e)
        raise Exception('400: Unexpected error')
    return "Voucher successfully registered"

def voucherfactory(campaign, email, dynamodb=None):
    if not dynamodb:
        dynamodb = boto3.resource('dynamodb', 
                                  aws_access_key_id="anything",
                                  aws_secret_access_key="anything",
                                  region_name="eu-west-1",
                                  endpoint_url="http://localhost:8000")
    campaign_data = claim_voucher(campaign, dynamodb)

    campaignid = int(campaign_data['Attributes']['CampaignId'])
    expiration = int(campaign_data['Attributes']['Expiration'])
    if expiration < int(time()):
        raise CampaignExpiredError
    return register_voucher(campaign, campaignid, email, expiration, dynamodb)
     
def claim_voucher(campaign, dynamodb):
    table = dynamodb.Table('Campaigns')
    try:
        response = table.update_item(
            Key={ 'Campaign' : campaign },
            UpdateExpression="set Available = Available - :increment",
            ExpressionAttributeValues={
                ':increment': Decimal(1),
                ':zero': Decimal(0),
            },
            ConditionExpression="Available > :zero",
            ReturnValues="ALL_NEW"
        )
    except ClientError as e:
        if e.response['Error']['Code'] == "ConditionalCheckFailedException":
            raise VoucherDepletionError
        else:
            raise
    else:
        return response

# The resulting voucher should be of length 16, this is not a secure algorithm
def generate_voucherid(campaignid, expiration):
    data = struct.pack('>III', expiration, campaignid, secrets.randbits(32))
    print(data)
    print(len(data))
    print(base64.b64encode( data ))
    return base64.b64encode( data )

def register_voucher(campaign, campaignid, email, expiration, dynamodb):
    table = dynamodb.Table('Vouchers')
    i = 0
    while i < 10:
        i += 1
        voucherid = generate_voucherid(campaignid, expiration)
        try:
            response=table.put_item(
                Item={
                    'Voucher': voucherid,
                    'Campaign': campaign,
                    'Email': email,
                    'Expiration': expiration,
                    'Active': 1
                },
                ConditionExpression="attribute_not_exists(Campaign)"
            )
        except ClientError as e:
            if e.response['Error']['Code'] == 'ConditionalCheckFailedException':
                continue
            else:
                raise 
        except:
            raise
        else:
            return response
    raise Exception

if __name__ == '__main__':
    print("Claiming voucher...")
    result, claim_response = claim_voucher("TestCampaign")
    if result:
        print("Claim successfull:")
        pprint(claim_response, sort_dicts=False)
