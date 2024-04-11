
FROM python:3.9

# Définissez le répertoire de travail dans l'image
WORKDIR /app

# Copiez le code source dans l'image
COPY . /app

# Installez les dépendances Python
RUN pip install -r requirements.txt

# Exposez le port si votre application écoute sur un port spécifique
# EXPOSE 8080

# Commande par défaut à exécuter lorsque l'image est démarrée
CMD ["python", "main.py"]
