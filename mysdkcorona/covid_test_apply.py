from covid_data_api import get_data_day
from covid_data_api import get_trend
from covid_data_api import lockdown_boolean
from covid_data_api import covid_data_json
from covid_data_api import write_json_file
from covid_s3 import create_s3
from covid_s3 import upload_file_s3

data_to_save= get_data_day()
trend =get_trend(data_to_save)
lockdown= lockdown_boolean(data_to_save)
covid_data_gen= covid_data_json(data_to_save,trend,lockdown)
write_json_file(covid_data_gen)
create_s3()
upload_file_s3()