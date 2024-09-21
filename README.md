# AWS-cloud-project-two---Parking-Lots-Monitoring

This project showcases how to deploy lambdas in a VPC. I am using 2 availability zones. For redundancy, I have created 1 private and 1 public subnets in each availability zone. The lambda will be in the private subnet. It will be able to access Internet via a NAT gateway that is placed in each of the public subnets. The lambda will access the LTA Datamall api to retrieve data regarding the parking lot availabilty and input these data into dynamodb.

An API Gateway endpoint is also created to retrieve data from dynamodb.The architecture diagram is shown below.

![parking_lots drawio](https://github.com/user-attachments/assets/a310d8f6-53e3-4f5d-9859-1f3c7fdec80b)


Steps to deploy terraform:
- cd lambdas/get_parking_lots
- pip3 install -r requirements.txt --target package
- cd package;zip -r ../get_parking_lots.zip .
- cd ..
- zip -r get_parking_lots.zip get_parking_lots.py
- Repeat the steps above for update_parking_lots and remember to replace all filenames to update_parking_lots.zip  and update_parking_lots.py
- Go back to the root directory.
- cd terraform
- if you are using linux terminal, please export your AWS credentials
- ./run_script.sh
