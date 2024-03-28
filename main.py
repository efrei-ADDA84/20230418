import os
import requests


def get_weather():
    lat = float(os.environ.get('LATITUDE', 0))
    long = float(os.environ.get('LONGITUDE', 0))

    if lat == 0 or long == 0:
        raise ValueError("Latitude and longitude not provided. Set LATITUDE and LONGITUDE environment variables.")

    api_key = os.environ.get('OPENWEATHER_API_KEY')
    if not api_key:
        raise ValueError("API key not found. Set OPENWEATHER_API_KEY environment variable.")

    url = f"https://api.openweathermap.org/data/2.5/weather?lat={lat}&lon={long}&appid={api_key}"
    response = requests.get(url)

    if response.status_code != 200:
        raise Exception(f"Error: {response.status_code}")

    data = response.json()
    return data


if __name__ == "__main__":

    weather_data = get_weather()
    print(weather_data)
