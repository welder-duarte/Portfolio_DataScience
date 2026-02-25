from datetime import date
import os, requests

from scraping.scraper import extract_ranking, upload_to_gcs,transform_to_dataframe
from pipelines.raw_loader import raw_load
from pipelines.raw_to_silver import merge_silver

BUCKET_NAME = os.getenv("BUCKET_NAME")


def run_pipeline():
    scraping_date = date.today().isoformat()

    raw_data = extract_ranking()
    df = transform_to_dataframe(raw_data)
    upload_to_gcs(df)

    #raw_load(scraping_date, BUCKET_NAME)

    #merge_silver(scraping_date)

    #TRIGGER PARA DBT RUNNER
    requests.post("https://dbt-runner-url.run.app")

    return "Pipeline executado com sucesso", 200


if __name__ == "__main__":
    run_pipeline()
