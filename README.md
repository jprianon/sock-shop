# Sock Shop

Le projet Sock Shop est une application de microservices qui simule une boutique en ligne pour acheter des chaussettes. Cette application est conçue pour démontrer les concepts de déploiement de microservices sur le cloud avec des outils DevOps.

## Table des matières

- [Caractéristiques](#caractéristiques)
- [Architecture](#architecture)
- [Technologies utilisées](#technologies-utilisées)
- [Installation](#installation)
- [Déploiement](#déploiement)
- [Utilisation](#utilisation)
- [Contribuer](#contribuer)
- [Licence](#licence)

## Caractéristiques

- Microservices modulaires pour chaque fonctionnalité de la boutique
- Intégration avec AWS pour le déploiement
- Utilisation de Helm pour la gestion des packages Kubernetes
- Surveiller la performance avec Grafana et Prometheus

## Architecture

![Architecture](path_to_your_architecture_diagram.png) <!-- Assurez-vous d'ajouter un diagramme d'architecture si disponible -->

## Technologies utilisées

- Kubernetes
- AWS (EKS)
- Helm
- Docker
- Prometheus
- Grafana
- Ansible

## Installation

1. Clonez le dépôt :

   ```bash
   git clone https://github.com/jprianon/sock-shop.git
   cd sock-shop

3. Renseigner les access key de votre compte AWS
   
   ```bash
   export AWS_ACCESS_KEY_ID=YOUR_ACCESS_KEY_ID
   export AWS_SECRET_ACCESS_KEY=YOUR_SECRET_ACCESS_KEY

2. Allez dans le dossier terraform et exécutez ces commandes pour lancer l'environnement.

   ```bash
   terraform init && terraform plan && terraform apply

3. Une fois l'environnement en place vous pouvez lancer le déploiement via Helm avec le scipt bash à cette effet : 
   
   ```bash
   cd microservices/
   ./deploy-all-dev.sh


