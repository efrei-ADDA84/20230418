# Rapport README TP3 - Projet d'API DEPLOYE SUR UN CONTAINER INSTANCE

## Introduction
Ce projet vise à créer une API en utilisant Flask et Python, en se basant sur l'API de OpenWeather, de mettre à disposition une image sur Azure Container Registry et de déployer l'API sur une Azure Container Instance via des GitHub Actions.

## Contexte
Au cours du développement de ce projet, j'ai rencontré plusieurs défis que j'ai dû surmonter :

### Installation de Docker Desktop
J'ai rencontré des difficultés lors de l'installation de Docker Desktop sur mon système. Pour continuer à travailler sur le projet, j'ai décidé de passer à une machine virtuelle Linux où j'ai pu installer et exécuter Docker sans problème.

### le code l'api
Je me suis servi du code de l'API du TP2 avec juste quelques modifications pour qu'il puisse écouter le port 80 (port d'écoute de ma container registry par défaut) ainsi que toutes les adresses IP du réseau avec ```host="0.0.0.0"```.

### construction du workflow
La construction du workflow a été la partie la plus compliquée de ce TP car ayant commencé sur de mauvaises bases, je n'arrivais pas à m'authentifier sur Azure via les CREDENTIALS. Mais ensuite avec l'utilisation des GitHub Actions, j'ai pu construire un workflow en parfait accord avec l'énoncé de l'exercice. Nous pouvons noter en passant l'indication de l'API_KEY dans les variables d'environnements du container instance qui nous permet de ne pas l'écrire en dur dans le code.

### deploiement
Le déploiement se fait à chaque push sur notre branche master de GitHub. Le déploiement final du container instance s'est très bien déroulé et peut être testé via la commande : ```curl "http://devops-20230418.germanynorth.azurecontainer.io/?lat=5.902785&lon=102.754175" ```

## Découvertes
Ce projet m'a donné l'occasion de déployer une container instance sur Azure et de pouvoir ainsi accéder à mon API depuis une adresse. Le code principal de l'API est fourni ci-dessous :

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
    app.run(debug=True, port=80, host="0.0.0.0")

```
Ce code crée une API Flask qui récupère les données météorologiques en fonction des coordonnées de latitude et de longitude fournies en paramètres d'URL. L'API utilise une clé d'API OpenWeather stockée dans une variable d'environnement de mon container instance pour l'authentification.