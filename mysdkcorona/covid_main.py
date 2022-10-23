import requests
import json 
import boto3

s3 = boto3.resource("s3")
url= "https://api.covid19api.com/country/germany?from=2020-10-20T00:00:00Z&to=2020-10-26T00:00:00Z"
response=requests.get(url)
data_to_save = response.json()
data_day =  data_to_save[6]

if data_to_save[0]["Confirmed"] < data_to_save[6]["Confirmed"]:
    trend = "UP"
elif data_to_save[0]["Confirmed"] > data_to_save[6]["Confirmed"]:
    trend = "DOWN"
else:
    trend = "EQUAL"    

sum_sevendays=0
counter=0
while counter <7:
    sum_sevendays = sum_sevendays + data_to_save[counter]["Active"]
    counter +=1     
    if sum_sevendays > 10000:
        lockdown = True
    elif sum_sevendays < 0:
        lockdown = False   
    elif sum_sevendays == 0:
        lockdown = "No Lockdown"


covid_data_gen = {
    "country":data_day["Country"],
    "cases":data_day["Confirmed"],
    "active":data_day["Active"],
    "trend":trend,
    "lockdown": lockdown
}

with open("covid_data.json", "w") as file:
    file.write(json.dumps(covid_data_gen))


AWS_REGION = "us-east-2"
client = boto3.client('s3',region_name=AWS_REGION)
location = {'LocationConstraint': AWS_REGION}
client.create_bucket(Bucket="coviddatas3buck",CreateBucketConfiguration=location)    
s3.meta.client.upload_file('covid_data.json', 'coviddatas3buck', 'covid_data.json')





"""return covid_data_gen['cases']

pprint.pprint(sorted(covid_data_gen, key=sory_by_cases))    """



       
    