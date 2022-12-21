import pandas as pd
import pendulum

from airflow import DAG
from airflow.operators.python_operator import PythonOperator
from datetime import datetime, timedelta


def get_data_timeline():

    # date interval
    START_DATE = datetime.today()
    END_DATE = START_DATE + timedelta(days=7)

    # formating date
    START_DATE = START_DATE.strftime("%Y-%m-%d")
    END_DATE = END_DATE.strftime("%Y-%m-%d")

    CITY = "Boston"
    KEY = ""

    PARAMS_TO_URL = [
        "https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline/"
        ,CITY,"/"
        ,START_DATE,"/"
        ,END_DATE
        ,"?unitGroup=metric"
        ,"&include=days"
        ,"&key=",KEY
        ,"&contentType=csv"
    ]

    URL = "".join(PARAMS_TO_URL)

    data = pd.read_csv(URL)

    print(data)



with DAG(
    "visual_crossing_extract",
    start_date=pendulum.datetime(2022, 12, 19, tz="UTC"),
    schedule_interval="0 0 * * 1"
) as dag:

    timeline_extract = PythonOperator(
        task_id = "timeline_extract",
        python_callable = get_data_timeline
    )


(timeline_extract)
    