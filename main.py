import os
from flask import Flask, jsonify, request
import requests

app = Flask(__name__)

@app.route('/', methods=['GET'])
def get_weather():
    lat = request.args.get('lat')
    lon = request.args.get('lon')

    if not lat or not lon:
        return jsonify({'error': 'Latitude and longitude not provided.'}), 400

    api_key = os.environ.get('API_KEY')
    if not api_key:
        return jsonify({'error': 'API key not found. Set API_KEY environment variable.'}), 500

    url = f"https://api.openweathermap.org/data/2.5/weather?lat={lat}&lon={lon}&appid={api_key}"
    response = requests.get(url)

    if response.status_code != 200:
        return jsonify({'error': f'Error: {response.status_code}'}), 500

    data = response.json()
    return jsonify(data), 200

if __name__ == "__main__":
    app.run(debug=True, port=8081)

