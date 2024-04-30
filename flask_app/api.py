import subprocess
from flask import Flask, request
from flask_cors import CORS

app = Flask(__name__)
CORS(app)

@app.route("/api", methods=["GET"])
def show_saved_wifi() -> dict:
    if request.method == "GET":
        saved_wifi = {}
        result = subprocess.check_output(["ls", "/etc/NetworkManager/system-connections/"])
        saved_wifi["result"] = {
            "saved_connections": result,
        }
        return saved_wifi


if __name__ == "__main__":
    app.run(debug=True, host="0.0.0.0", port=80)
