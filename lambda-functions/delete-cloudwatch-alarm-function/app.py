import json
import boto3
import os

cloudwatch = boto3.client('cloudwatch')

def delete_alarm(function_name):
    alarm_name = f'{function_name}-lambda-alerts'
    response = cloudwatch.delete_alarms(AlarmNames=[alarm_name])
    return response

def lambda_handler(event, context):
    # Extract the Lambda function name from the event
    function_name = event['detail']['requestParameters']['functionName']
    deleted_alarm = delete_alarm(function_name)

    return {
        'statusCode': 200,
        'body': json.dumps(deleted_alarm)
    } 
