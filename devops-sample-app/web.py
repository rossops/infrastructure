#!/usr/bin/python3
from flask import Flask
app = Flask(__name__)

@app.route('/healthcheck', methods=['GET'])
def get_health():
    """
    api endpoint for a basic health check
    :return: health check string
    :rtype: string
    """
    return {'healthcheck': 'ok'}, 200

@app.route('/', methods=['GET'])
def index():
    """
    basic root web page
    :return:  web page string
    :rtype: string
    """
    return {'root': 'Hello, World!'}, 200

def main():
    app.run(debug=False)


if __name__ == '__main__':
    main()
