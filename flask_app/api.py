import subprocess
import re
from flask import Flask, request
from flask_cors import CORS

app = Flask(__name__)
CORS(app)

valid_queries = ["show_connections", "show_credentials"]


@app.route("/api", methods=["GET"])
def handle_queries() -> str | None:
    query = request.query_string.decode("utf-8")[
        : request.query_string.decode("utf-8").find("=")
    ]
    if request.method == "GET" and query in valid_queries:
        if query == "show_connections":
            return show_connections()
        if query == "show_credentials":
            # return get_credentials(request.args["show_credentials"])
            return show_credentials(request.args["show_credentials"])
    return f"QUERY: {query}\nNot a valid query."


def show_connections() -> dict:
    return {"saved_connections": saved_connections}


def get_connections() -> list:
    saved_wifi = []
    show_wifi = str(
        subprocess.check_output(["ls", "/etc/NetworkManager/system-connections/"])
    )
    for i in show_wifi.split(","):
        saved_wifi.append(re.findall(r"'(.*?)'", i)[0].replace("\\n", ""))
    return saved_wifi


def get_credentials(ssid) -> dict:
    # TODO: parse connection info as dict
    if ssid in saved_connections:
        return str(
            subprocess.check_output(
                ["cat", f"/etc/NetworkManager/system-connections/{ssid}"]
            )
        )
    return f"SSID: {ssid}\nNot in saved connections."


def get_all_credentials() -> list:
    # TODO: return list of get_credentials using saved_connections list
    pass


def show_credentials(ssid) -> dict:
    return {request.args["show_credentials"]: get_credentials(ssid)}


saved_connections = get_connections()

if __name__ == "__main__":
    app.run(debug=True, host="0.0.0.0", port=80)
