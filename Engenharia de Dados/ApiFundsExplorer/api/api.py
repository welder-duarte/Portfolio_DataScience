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
                query += " AND setor LIKE CONCAT('%', @setor, '%')"
                parameters.append(bigquery.ScalarQueryParameter("setor", "STRING", setor))

            if fundo:
                query += " AND fundos = @fundo"
                parameters.append(bigquery.ScalarQueryParameter("fundo", "STRING", fundo))

            query += " ORDER BY fundos LIMIT @limite"
            parameters.append(bigquery.ScalarQueryParameter("limite", "INT64", limite))

            job_config = bigquery.QueryJobConfig(query_parameters=parameters)
            query_job = client.query(query, job_config=job_config)
            #results = [dict(row) for row in query_job]
            #return api_response(data=results)
        
            results = [{
                "fundos": row["fundos"],
                "setor": row["setor"],
                "dt_atualizacao": row["dt_atualizacao"].isoformat(),
                "ultimo_dividendo": float(row["ultimo_dividendo"]) if row["ultimo_dividendo"] is not None else 0.0,
                "dividend_yield": float(row["dividend_yield"]) if row["dividend_yield"] is not None else 0.0,
                "dy_ano": float(row["dy_ano"]) if row["dy_ano"] is not None else 0.0,
                "dy_3m_med": float(row["dy_3m_med"]) if row["dy_3m_med"] is not None else 0.0,
                "dy_3m_acum": float(row["dy_3m_acum"]) if row["dy_3m_acum"] is not None else 0.0,
                "dy_6m_med": float(row["dy_6m_med"]) if row["dy_6m_med"] is not None else 0.0,
                "dy_6m_acum": float(row["dy_6m_acum"]) if row["dy_6m_acum"] is not None else 0.0,
                "dy_12m_med": float(row["dy_12m_med"]) if row["dy_12m_med"] is not None else 0.0,
                "dy_12m_acum": float(row["dy_12m_acum"]) if row["dy_12m_acum"] is not None else 0.0,
                "preco_atual": float(row["preco_atual"]) if row["preco_atual"] is not None else 0.0,
                "preco_fechamento": float(row["preco_fechamento"]) if row["preco_fechamento"] is not None else 0.0,
                "variacao_preco_m": float(row["variacao_preco_m"]) if row["variacao_preco_m"] is not None else 0.0,
                "variacao_preco_ult_pregao": float(row["variacao_preco_ult_pregao"]) if row["variacao_preco_ult_pregao"] is not None else 0.0,
                "volatilidade": float(row["volatilidade"]) if row["volatilidade"] is not None else 0.0,
                "rentab_acum": float(row["rentab_acum"]) if row["rentab_acum"] is not None else 0.0,
                "rentab_periodo": float(row["rentab_periodo"]) if row["rentab_periodo"] is not None else 0.0,
                "patrimonio": float(row["patrimonio"]) if row["patrimonio"] is not None else 0.0,
                "patrimonio_liquido": float(row["patrimonio_liquido"]) if row["patrimonio_liquido"] is not None else 0.0,
                "vpa": float(row["vpa"]) if row["vpa"] is not None else 0.0,
                "pvp": float(row["pvp"]) if row["pvp"] is not None else 0.0,
                "p_vpa": float(row["p_vpa"]) if row["p_vpa"] is not None else 0.0,
                "vpa_yield": float(row["vpa_yield"]) if row["vpa_yield"] is not None else 0.0,
                "vpa_change": float(row["vpa_change"]) if row["vpa_change"] is not None else 0.0,
                "vpa_rent": float(row["vpa_rent"]) if row["vpa_rent"] is not None else 0.0,
                "vpa_rent_m": float(row["vpa_rent_m"]) if row["vpa_rent_m"] is not None else 0.0,
                "liquidez_diaria": float(row["liquidez_diaria"]) if row["liquidez_diaria"] is not None else 0.0,
                "numero_cotista": int(row["numero_cotista"]) if row["numero_cotista"] is not None else 0,
                "ativos": int(row["ativos"]) if row["ativos"] is not None else 0,
                "tx_gestao": float(row["tx_gestao"]) if row["tx_gestao"] is not None else 0.0,
                "tx_admin": float(row["tx_admin"]) if row["tx_admin"] is not None else 0.0,
                "tx_performance": float(row["tx_performance"]) if row["tx_performance"] is not None else 0.0,}
                for row in query_job ]
            return api_response(data=results)

    except Exception as e:
        logging.exception("Error querying BigQuery")
        return api_response(success=False,message=str(e),status=500)


@app.route("/health", methods=["GET"])
def health():
    return jsonify({"status": "ok"}), 200


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080)
