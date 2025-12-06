from flask import Flask, jsonify
import time, random

app = Flask(__name__)

@app.route('/')
def home():
    # simulate a metric
    return jsonify({"message":"Hello from RealTimeOps!", "value": random.randint(1,100), "time":time.time()})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=7070)

