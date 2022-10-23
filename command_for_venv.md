create covid data program
to make virtual environment=> 
""""python3 -m venv venv_corona_data
source venv_corona_data
source /bin/activate
pip3 install requests
pip3 install boto3""""
create vpc,subnet,route,igw,ec2 instance using terraform
commands to run
"""terraform init
terraform plan
terraform apply
terraform destroy"""



resource "aws_s3_bucket" "corona-api" {
  bucket = "coviddatas3buck"
  tags = {
    Description = "Bucket for corona api"
  }
}
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