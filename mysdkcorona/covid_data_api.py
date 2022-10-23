import requests
import json 

def get_data_day():
    url= "https://api.covid19api.com/country/germany?from=2020-10-20T00:00:00Z&to=2020-10-26T00:00:00Z"
    response=requests.get(url)
    data_to_save = response.json()
    return data_to_save
   

def get_trend(data_to_save):
    if data_to_save[0]["Confirmed"] < data_to_save[6]["Confirmed"]:
        trend = "UP"
    elif data_to_save[0]["Confirmed"] > data_to_save[6]["Confirmed"]:
        trend = "DOWN"
    else:
        trend = "EQUAL" 
    return trend

def lockdown_boolean(data_to_save):
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
        return lockdown       

def covid_data_json(data_to_save,trend,lockdown):
    data_day =  data_to_save[6]
    covid_data_gen = {
    "country":data_day["Country"],
    "cases":data_day["Confirmed"],
    "active":data_day["Active"],
    "trend":trend,
    "lockdown": lockdown
}
    return covid_data_gen

def write_json_file(covid_data_gen):
    with open("covid_data.json", "w") as file:
        file.write(json.dumps(covid_data_gen))