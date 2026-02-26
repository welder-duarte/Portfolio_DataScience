import subprocess, json, logging
from flask import Flask, jsonify, request

app = Flask(__name__)
logging.basicConfig(level=logging.INFO)

@app.route("/", methods=["POST"])
def run_dbt():
    logging.info("DBT execution started")

    result = subprocess.run(["dbt", "run"], capture_output=True, text=True, cwd="/app")

    log_payload = {"returncode": result.returncode,"stdout": result.stdout,"stderr": result.stderr}

    if result.returncode != 0:
        logging.error(json.dumps(log_payload))
        return jsonify({"status": "error"}), 500

    logging.info(json.dumps(log_payload))
    return jsonify({"status": "success"}), 200


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080)