import json
import os
import time
from aws_lambda_powertools.event_handler import APIGatewayRestResolver
from aws_lambda_powertools.utilities.typing import LambdaContext
import boto3
from botocore.config import Config


table_name = os.environ.get("TABLE_NAME")

# table_name = "PARKING_LOTS"
dynamodb_client = boto3.client('dynamodb')
app = APIGatewayRestResolver()


@app.get("/parking_lots/<development>")
def get_parking_lot(development: str):

    try:
        response = dynamodb_client.query(

            TableName=table_name,
            KeyConditionExpression=f'Development = :Development',
            ExpressionAttributeValues={
                ':Development': {'S': development}
            })

        if response['Items']:
            return {

                "statusCode": 200,
                "body": json.dumps({"lots": response['Items'][0]['AvailableLots']['N']})

            }
        else:
            return {
                "statusCode": 404,
                "body": json.dumps({"message": "Error: Location Not Found"})
            }

    except Exception as e:
        return {
            "statusCode": 500,
            "body": json.dumps({"message": f"Error:{e}"})
        }


def lambda_handler(event: dict, context: LambdaContext):
    return app.resolve(event, context)
