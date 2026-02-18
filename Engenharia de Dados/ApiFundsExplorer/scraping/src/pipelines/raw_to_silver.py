import os
from google.cloud import bigquery
from datetime import datetime

SQL_DIR = os.path.join(os.path.dirname(os.path.dirname(__file__)), "sql")


def merge_silver(scraping_date: str):
    client = bigquery.Client()

    sql_path = os.path.join(SQL_DIR, "merge_raw_to_silver.sql")

    with open(sql_path, "r", encoding="utf-8") as f:
        query = f.read()

    scraping_date_obj = datetime.strptime(scraping_date, "%Y-%m-%d").date()

    job_config = bigquery.QueryJobConfig(
        query_parameters=[
            bigquery.ScalarQueryParameter(
                "scraping_date",
                "DATE",
                scraping_date_obj)])

    #query = query.replace("@scraping_date", scraping_date)

    print("Executando query incremental silver no BigQuery...")
    job = client.query(query,job_config=job_config)
    job.result()
    print("Carga incremental finalizada")
