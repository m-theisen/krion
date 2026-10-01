import time
from flask import Flask, jsonify
import requests

app = Flask(__name__)

UPSTREAM_URL = "https://api.github.com/zen"

@app.route("/fetch", methods=["GET"])
def fetch():
    start_time = time.time()
    try:
        response = requests.get(UPSTREAM_URL, timeout=15)
        elapsed = round(time.time() - start_time, 2)
        
        return jsonify({
            "status": "success",
            "latency_seconds": elapsed,
            "data": response.text.strip()
        })
    except Exception as e:
        elapsed = round(time.time() - start_time, 2)
        return jsonify({
            "status": "error",
            "latency_seconds": elapsed,
            "error_details": str(e)
        }), 500

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080)
