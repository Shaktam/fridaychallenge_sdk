import json 
import boto3

def create_s3():
    AWS_REGION = "us-east-2"
    client = boto3.client('s3',region_name=AWS_REGION)
    location = {'LocationConstraint': AWS_REGION}
    client.create_bucket(Bucket="coviddatas3buck",CreateBucketConfiguration=location)  

def upload_file_s3():
    s3 = boto3.resource("s3")
    s3.meta.client.upload_file('covid_data.json', 'coviddatas3buck', 'covid_data.json')
