import subprocess
from flask import Flask, jsonify

app = Flask(__name__)

@app.route("/", methods=["POST"])
def run_dbt():
    result = subprocess.run(
        ["dbt", "run"],
        capture_output=True,
        text=True,
        cwd="/app")

    return jsonify({
        "returncode": result.returncode,
        "stdout": result.stdout,
        "stderr": result.stderr
    }), 200


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080)