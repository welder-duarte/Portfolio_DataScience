import os
from google.cloud import bigquery

SQL_DIR = os.path.join(os.path.dirname(os.path.dirname(__file__)), "sql")

def raw_load(scraping_date: str, bucket_name: str):
    client = bigquery.Client()

    sql_path = os.path.join(SQL_DIR, "raw_load_data.sql")

    gcs_uri = (f"gs://{bucket_name}/raw/funds_explorer/scraping_date_{scraping_date}/funds.csv")

    with open(sql_path, "r", encoding="utf-8") as f:
        query = f.read()

    query = query.replace("@scraping_date", scraping_date)
    query = query.replace("{GCS_URI}", gcs_uri)

    print("Executando query RAW no BigQuery...")
    job = client.query(query)
    job.result()
    print("Carga Raw finalizada")
