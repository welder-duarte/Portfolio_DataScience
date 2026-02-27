from flask import Flask, request, jsonify
from google.cloud import bigquery
import logging

app = Flask(__name__)
client = bigquery.Client()

PROJECT_ID = "apifundsexplorer"
DATASET = "funds_explorer"
TABLE = "gold_funds_ranking"

import unicodedata

def normalize_string(value):
    if not value:
        return value

    value = value.upper()
    value = unicodedata.normalize("NFD", value)
    value = value.encode("ascii", "ignore").decode("utf-8")
    return value


def api_response(data=None, success=True, message=None, status=200):
    response = {"success": success,"data": data}

    if isinstance(data, list):
        response["total"] = len(data)

    if message:
        response["message"] = message

    return jsonify(response), status

@app.route("/v1/funds", methods=["GET"])
def get_funds():
    limite = request.args.get("limite", default=20, type=int)
    setor = normalize_string(request.args.get("setor"))
    fundo = normalize_string(request.args.get("fundo"))
    listar_fundos = request.args.get("listar_fundos", type=bool)

    try:
        if listar_fundos:
            query = f"""SELECT DISTINCT fundos, setor FROM `{PROJECT_ID}.{DATASET}.{TABLE}` ORDER BY fundos"""
            job_config = bigquery.QueryJobConfig()
            query_job = client.query(query, job_config=job_config)
            
            results = [dict(row) for row in query_job]
            return api_response(data=results)

        else:
            query = f"""SELECT * FROM `{PROJECT_ID}.{DATASET}.{TABLE}` WHERE 1=1"""

            parameters = []

            if setor:
                query += " AND setor = @setor"
                parameters.append(bigquery.ScalarQueryParameter("setor", "STRING", setor))

            if fundo:
                query += " AND fundos = @fundo"
                parameters.append(bigquery.ScalarQueryParameter("fundo", "STRING", fundo))

            query += " ORDER BY fundos LIMIT @limite"
            parameters.append(bigquery.ScalarQueryParameter("limite", "INT64", limite))

            job_config = bigquery.QueryJobConfig(query_parameters=parameters)
            query_job = client.query(query, job_config=job_config)
            results = [dict(row) for row in query_job]

            return api_response(data=results)

    except Exception as e:
        logging.exception("Error querying BigQuery")
        return api_response(success=False,message=str(e),status=500)


@app.route("/health", methods=["GET"])
def health():
    return jsonify({"status": "ok"}), 200


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080)
