create covid data program
to make virtual environment=> 
""""python3 -m venv venv_corona_data
source venv_corona_data/bin/activate
pip3 install requests
pip3 install boto3""""
create vpc,subnet,route,igw,ec2 instance using terraform
commands to run
"""terraform init
terraform plan
terraform apply
terraform destroy"""




resource "aws_s3_object_copy" "s3bucket_json" {
  bucket = "my_sdktfec2"
  key    = "covid_data.json"
  source = "coviddatas3buck/covid_data.json"

  grant {
    uri         = "https://coviddatas3buck.s3.us-east-2.amazonaws.com/covid_data.json"
    type        = "Group"
    permissions = ["FULL_CONTROL"]
  }
}
# data "aws_iam_group" "corona-data" {
#   group_name = "corona-api-group"
# }

resource "aws_s3_bucket" "corona-api" {
  bucket = "covid-data-s3bucket"
  tags = {
    Description = "Bucket for corona api"
  }
}
resource "aws_s3_bucket_object" "corona-api-script" {
  content = "sdk_friday_21-10/mysdkcorona/covid_test_apply.py"
  key = "covid_test_apply.py"
  bucket = aws_s3_bucket.corona-api.id
}
resource "aws_s3_bucket" "acl" {
  bucket = "ovid-data-s3bucket"
  acl    = "public-read"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}