import subprocess
import json
import time
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


@app.route("/rec_creds", methods=["GET"])
def handle_queries() -> str | None:
    if request.method == "GET":
        query = request.query_string.decode("utf-8")
        find_query = query.find("=")
        if find_query != -1:
            query = query[:find_query]
        if query in valid_queries:
            if query == "show_connections":
                return show_connections()
            if query == "show_credentials":
                return show_credentials(request.args["show_credentials"])
        return f"QUERY: {query}\nNot a valid query."


@app.route("/send_creds", methods=["POST"])
def save_credentials() -> str | None:
    if request.method == "POST":
        r = json.loads(request.data)
        disable_hotspot()
        time.sleep(3)
        if connect_wifi(r["SSID"], r["PASS"]):
            return "Connected"
        return "Error connecting"


def show_connections() -> dict:
    return {"saved_connections": saved_connections}


def get_connections() -> list:
    show_wifi = subprocess.check_output(
        ["ls", "/etc/NetworkManager/system-connections/"]
    )
    return show_wifi.decode("utf-8").splitlines()


def get_credentials(ssid) -> dict:
    saved_connections = get_connections()
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
    if start == -1:
        return [ingest[:-1], ""]
    return split


def enable_hotspot(ssid, password) -> None:
    subprocess.run(
        [
            "nmcli",
            "device",
            "wifi",
            "hotspot",
            "ssid",
            ssid,
            "password",
            password,
            "ifname",
            "wlan0",
        ],
        check=False,
    )


def setup_hotspot() -> None:
    subprocess.run(["sh", "ap_setup.sh"], check=False)


def disable_hotspot() -> None:
    subprocess.run(["nmcli", "r", "wifi", "off"], check=False)
    subprocess.run(["nmcli", "r", "wifi", "on"], check=False)


def connect_wifi(ssid, password) -> bool:
    check_wifi = subprocess.check_output(
        ["nmcli", "device", "wifi", "connect", ssid, "password", password]
    )
    if "successfully" in check_wifi.decode("utf-8"):
        return True
    return False


saved_connections = get_connections()

if __name__ == "__main__":
    app.run(debug=True, host="0.0.0.0", port=80)
