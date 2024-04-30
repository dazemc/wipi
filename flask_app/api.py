import subprocess
import re
from flask import Flask, request
from flask_cors import CORS

app = Flask(__name__)
CORS(app)

valid_queries = ["show_connections"]


@app.route("/api", methods=["GET"])
def handle_queries() -> str | None:
    query = request.query_string.decode("utf-8")
    if request.method == "GET" and query in valid_queries:
        if query == "show_connections":
            return show_connections()
    return f"QUERY: {query}\nNot a valid query."


def show_connections() -> dict:
    saved_wifi = []
    output = {}
    show_wifi = str(
        subprocess.check_output(["ls", "/etc/NetworkManager/system-connections/"])
    )
    for i in show_wifi.split(","):
        saved_wifi.append(
            re.findall(r"'(.*?)'", i)[0].replace("\\n", "")
        )  # single line parse
    output["result"] = saved_wifi
    return output


if __name__ == "__main__":
    app.run(debug=True, host="0.0.0.0", port=80)
