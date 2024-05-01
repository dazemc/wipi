import subprocess
import re
from flask import Flask, request
from flask_cors import CORS

app = Flask(__name__)
CORS(app)

valid_queries = ["show_connections", "show_credentials"]
connection_values = [
    "id=",
    "uuid=",
    "type=",
    "autoconnect=",
    "interface-name=",
    "timestamp=",
    "mode=",
    "ssid=",
    "group=",
    "key-mgmt=",
    "pairwise=",
    "proto=",
    "psk=",
    "method=",
    "addr-gen-mode=",
    "method=",
]


@app.route("/api", methods=["GET"])
def handle_queries() -> str | None:
    query = request.query_string.decode("utf-8")
    find_query = query.find("=")
    if find_query > 0:
        query = query[:find_query]
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
    if ssid in saved_connections:
        credentials = str(
            subprocess.check_output(
                ["cat", f"/etc/NetworkManager/system-connections/{ssid}"]
            )
        )
        creds_parsed = {}
        for v in connection_values:
            creds_parsed[v[:-1]] = parse_credentials(credentials, v)[1]
        return creds_parsed
    return f"SSID: {ssid}\nNot in saved connections."


def get_all_credentials() -> list:
    # TODO: return list of get_credentials using saved_connections list
    pass


def show_credentials(ssid) -> dict:
    return {request.args["show_credentials"]: get_credentials(ssid)}


def parse_credentials(credentials, ingest):
    start = credentials.find(ingest)
    section = credentials[start:]
    end = section.find("\\")
    value = section[:end]
    split = value.split("=")
    return split


saved_connections = get_connections()

if __name__ == "__main__":
    app.run(debug=True, host="0.0.0.0", port=80)
