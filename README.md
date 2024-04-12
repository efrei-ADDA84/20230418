# Rapport README TP2 - Projet d'API

## Introduction
Ce projet vise à créer une API en utilisant Flask et Python, en se basant sur l'API de OpenWeather. L'objectif est de mettre en place un pipeline d'intégration continue avec GitHub Actions pour construire et pousser l'API sur DockerHub.

## Contexte
Au cours du développement de ce projet, j'ai rencontré plusieurs défis que j'ai dû surmonter :

### Secrets GitHub
Pour sécuriser les identifiants Docker, j'ai choisi de les stocker en tant que secrets GitHub, ce qui permet de les utiliser dans le workflow GitHub Actions sans exposer les informations sensibles.

### Installation de Docker Desktop
J'ai rencontré des difficultés lors de l'installation de Docker Desktop sur mon système. Pour continuer à travailler sur le projet, j'ai décidé de passer à une machine virtuelle Linux où j'ai pu installer et exécuter Docker sans problème.

### Problèmes d'authentification GitHub sur Linux
J'ai également rencontré des problèmes d'authentification GitHub sur Linux. Pour résoudre ce problème, j'ai décidé d'utiliser une clé SSH pour l'authentification avec GitHub. Une fois la clé SSH configurée et ajoutée à mon compte GitHub, j'ai pu pousser et tirer des modifications depuis mon environnement Linux sans problème.

## Découvertes
Ce projet m'a permis de découvrir plusieurs outils et techniques. J'ai créé une GitHub Action qui se déclenche automatiquement après chaque push sur la branche principale (master). J'ai également déployé une API sur Docker. Le code principal de l'API est fourni ci-dessous :

```python
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
```
Ce code crée une API Flask qui récupère les données météorologiques en fonction des coordonnées de latitude et de longitude fournies en paramètres d'URL. L'API utilise une clé d'API OpenWeather stockée dans une variable d'environnement pour l'authentification.