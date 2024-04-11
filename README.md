# Rapport README TP2 - Projet d'API

## Introduction
Ce projet consiste à creer une API en se basant de l'API de OPEN WEATHER, la mettre sur github avec une github action pour build et push sur dockerhub 
## Contexte
Lors du développement de ce projet, j'ai rencontré plusieurs défis que j'ai dû surmonter :

### Github secrets
nous avons passé le user et le pwd de docker en secret sur github.

### Installation de Docker Desktop
J'ai rencontré des difficultés lors de l'installation de Docker Desktop sur mon système. Pour continuer à travailler sur le projet, j'ai décidé de passer à une machine virtuelle Linux où j'ai pu installer et exécuter Docker sans problème.

### Problèmes d'authentification GitHub sur Linux
J'ai également rencontré des problèmes d'authentification GitHub sur Linux. Pour résoudre ce problème, j'ai décidé d'utiliser une clé SSH pour l'authentification avec GitHub. Une fois la clé SSH configurée et ajoutée à mon compte GitHub, j'ai pu pousser et tirer des modifications depuis mon environnement Linux sans problème.

## Découvertes
Ce projet m'a permit de découvrir plusieurs outils. 
J'ai crée une github action qui se déclenche automatique après chaque push sur la branche master.
J'ai egalement deployé une api sur docker.
