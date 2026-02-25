import pandas as pd, os, requests
from datetime import date, datetime
from google.cloud import storage
from playwright.sync_api import sync_playwright
import google.auth
import google.auth.transport.requests

SQL_DIR = os.path.join(os.path.dirname(os.path.dirname(__file__)), "sql")

BUCKET_NAME = os.getenv("BUCKET_NAME", "seu-bucket")
DESTINATION_PREFIX = "raw/funds_ranking"

credentials, _ = google.auth.default()
auth_req = google.auth.transport.requests.Request()
credentials.refresh(auth_req)
id_token = credentials.token
headers = {"Authorization": f"Bearer {id_token}"}


def extract_ranking():
    with sync_playwright() as p:
        browser = p.chromium.launch(headless=True, args=["--no-sandbox","--disable-dev-shm-usage","--disable-blink-features=AutomationControlled"])
        context = browser.new_context()
        page = context.new_page()

        with page.expect_response(lambda r: "admin-ajax.php" in r.url and r.status == 200) as response_info:
            page.goto("https://www.fundsexplorer.com.br/ranking")

        response = response_info.value
        data = response.json()
        browser.close()
        print(f"Scraping finalizado")

        return data["data"]


def transform_to_dataframe(data):
    df = pd.DataFrame(data)
    df["scraping_date"] = date.today().isoformat()
    df["ingestion_timestamp"] = datetime.now()
    df = df.fillna("").astype(str)
    print(f"Dataframe criado com sucesso - {df.shape[0]} registros")
    return df


def upload_to_gcs(df):
    storage_client = storage.Client()
    bucket = storage_client.bucket(BUCKET_NAME)

    destination_path = (
        "raw/funds_explorer/"
        f"scraping_date_{date.today()}/"
        "funds.csv"
    )

    blob = bucket.blob(destination_path)
    csv_data = df.to_csv(index=False,encoding='utf-8',quoting=1)
    blob.upload_from_string(csv_data, content_type="text/csv")

    print(f"Upload concluído: gs://{BUCKET_NAME}/{destination_path}")


def main():
    raw_data = extract_ranking()
    df = transform_to_dataframe(raw_data)
    upload_to_gcs(df)

    #TRIGGER PARA DBT RUNNER
    response = requests.post("https://dbt-runner-187304865067.us-west1.run.app", headers=headers, json={}, timeout=30)

    if response.status_code != 200:
        raise Exception("Falha ao acionar dbt runner")

    print("Pipeline executado com sucesso")


if __name__ == "__main__":
    main()