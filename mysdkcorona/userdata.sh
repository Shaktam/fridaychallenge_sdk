#!/bin/bash

pip3 install requests
pip3 install boto3

cd /home/ec2-user/
wget https://github.com/Shaktam/fridaychallenge_sdk/blob/main/mysdkcorona/covid_test_apply.py
wget https://github.com/Shaktam/fridaychallenge_sdk/blob/main/mysdkcorona/covid_s3.py

crontab<<EOF
*/10 * * * * cd /home/ec2-user/ && python3 covid_s3.py
EOF