import json
import boto3
import os

dynamodb = boto3.resource('dynamodb')

def handler(event, context):
    table_name = os.environ.get('TABLE_NAME')
    table = dynamodb.Table(table_name)
    
    table.put_item(Item={
        'LockID': 'test-id-1',
        'Status': 'Success'
    })
    
    return {
        'statusCode': 200,
        'body': json.dumps('Data written to DynamoDB!')
    }
