#!bin/bash
pip3 install requests
pip3 install boto3

# Create python requirements file
echo """
requests==2.28.1
boto3==1.24.95
""" > /home/ec2-user/requirements.txt

# Install python modules
python3 -m pip install -r requirements.txt
# Create a cronjob to run your python script every 10 minutes
(crontab -l 2>/dev/null; echo "*/10 * * * * #!/bin/bash ~/./corona_data_apply.py") | crontab -