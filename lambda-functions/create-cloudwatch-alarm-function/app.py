import json
import boto3
import os

cloudwatch = boto3.client('cloudwatch')
sns_topic = os.getenv('sns_topic')

def create_alarm(function_name):
    response = cloudwatch.put_metric_alarm(
        AlarmName=f'{function_name}-lambda-alerts',
        AlarmDescription='Alarm when the specified Lambda function has errors',
        ActionsEnabled=True,
        MetricName='Errors',
        Namespace='AWS/Lambda',
        Statistic='Sum',
        Dimensions=[
            {
                'Name': 'FunctionName',
                'Value': function_name
            },
        ],
        Period=300,
        EvaluationPeriods=1,
        Threshold=20,
        ComparisonOperator='GreaterThanOrEqualToThreshold',
        OKActions=[
            sns_topic
        ],
        AlarmActions=[
            sns_topic
        ],
        TreatMissingData='missing'
    )

    return response

def lambda_handler(event, context):
    # Extract the Lambda function name from the event
    function_name = event['detail']['requestParameters']['functionName']

    alarm_name = create_alarm(function_name)

    print(alarm_name)

    return {
        'statusCode': 200,
        'body': json.dumps('CloudWatch alarm created successfully')
    } 
