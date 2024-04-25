from flask import Flask, request
from flask_cors import CORS

app = Flask(__name__)
CORS(app)


@app.route("/api", methods=["GET"])
def returnascii() -> dict:
    d = {}
    inputchr = str(request.args["query"])
    answer = str(ord(inputchr))
    d["output"] = answer
    return d


if __name__ == "__main__":
    app.run(host="0.0.0.0", debug=True)
