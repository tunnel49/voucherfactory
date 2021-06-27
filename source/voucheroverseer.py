import boto3
import secrets
import base64
import struct
from botocore.exceptions import ClientError
from decimal import Decimal
from pprint import pprint
from time import time

class VoucherUsedError(Exception):
    pass
class VoucherExpiredError(Exception):
    pass
class VoucherInvalidError(Exception):
    pass

def lambda_handler(event, context):
    dynamodb = boto3.resource('dynamodb',)
    try:
        voucher = bytes(event['voucher'],'utf8')
    except (ValueError, KeyError):
        raise Exception('400: Invalid input')
    except Exception as e:
        pprint(e)
        raise Exception('400: Unexpected error')
    try:
        voucheroverseer(voucher,dynamodb) 
    except (VoucherExpiredError, VoucherInvalidError):
        raise 
    except Exception as e:
        pprint(e)
        raise Exception('400: Unexpected error')
    return "Voucher successfully registered"

def voucheroverseer(voucher, dynamodb=None):
    if not dynamodb:
        dynamodb = boto3.resource('dynamodb', 
                                  aws_access_key_id="anything",
                                  aws_secret_access_key="anything",
                                  region_name="eu-west-1",
                                  endpoint_url="http://localhost:8000")
    epoch = int(time())
    data = base64.b64decode(voucher)
    print(voucher)
    print(data)
    print(len(data))
    if struct.unpack('>III', data)[0] < epoch:
        raise VoucherExpiredError('400: Voucher has expired')
    return retrieve_voucher(voucher, dynamodb)
    
def retrieve_voucher(voucher, dynamodb):
    table = dynamodb.Table('Vouchers')
    try:
        response = table.update_item(
            Key={ 'Voucher' : voucher },
            UpdateExpression="set Active = :false",
            ConditionExpression="Active = :true",
            ExpressionAttributeValues={
                ':false': Decimal(0),
                ':true': Decimal(1),
            }
        )
    except ClientError as e:
        if e.response['Error']['Code'] == "ConditionalCheckFailedException":
            raise VoucherInvalidError('400: Voucher is invalid')
        else:
            raise
    else:
        return response

