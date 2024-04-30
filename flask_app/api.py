import subprocess
import re
from flask import Flask, request
from flask_cors import CORS

app = Flask(__name__)
CORS(app)

@app.route("/api", methods=["GET"])
def show_saved_wifi() -> dict:
    if request.method == "GET":
        saved_wifi = []
        output = {}
        show_wifi = str(subprocess.check_output(["ls", "/etc/NetworkManager/system-connections/"]))
        for i in show_wifi.split(','):
            saved_wifi.append(re.findall(r"'(.*?)'", i).replace("\\n"), '')  # single line parse
        output["result"] = saved_wifi
        return output


if __name__ == "__main__":
    app.run(debug=True, host="0.0.0.0", port=80)
