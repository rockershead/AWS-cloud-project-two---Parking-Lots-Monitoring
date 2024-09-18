import requests
import boto3
import time
import os





table_name = os.environ.get("TABLE_NAME")
url = os.environ.get("URL")

dynamodb = boto3.resource('dynamodb')
ssm = boto3.client('ssm')
table = dynamodb.Table(table_name)
account_key = ""

try:
    response = ssm.get_parameter(
        Name="LTA_ACCOUNT_KEY",
        #WithDecryption=True  # Set to True if the parameter is encrypted (e.g., with KMS)
    )
    account_key = response['Parameter']['Value']
    print(f"Retrieved parameter value: {account_key}")
except Exception as e:
    print(f"Failed to retrieve parameter: {e}")

headers = {
    'AccountKey': account_key,
    'accept': 'application/json'  
}
places_to_check = ["Marina","Orchard"]

def lambda_handler(event, context):
  
    response = requests.get(url, headers=headers)


    try:
        if response.status_code == 200:
            data = response.json()
            filtered_data = [item for item in data['value'] if item['Area'] in places_to_check]
        
            for item in filtered_data:
                try:
                    item["Timestamp"] = int(time.time() * 1000)
                    table.put_item(Item=item)
                    print(f"Successfully inserted: {item}")
                except Exception as e:
                    print(f"Failed to insert {item}: {e}")
        
        else:
            print(f"Failed to retrieve data: {response.status_code}, {response.text}")

    except Exception as e:
        print(f"Failed to retrieve data:{e}")
