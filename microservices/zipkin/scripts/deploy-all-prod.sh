#!/bin/bash

# Déploiement des microservices pour l'environnement dev
services=("carts" "catalogue" "front-end" "ingress")

kubectl create namespace prod

for service in "${services[@]}"; do
  echo "Déploiement du service $service en prod..."
  helm upgrade --install $service ../$service/charts --values ../$service/charts/helm-values/values-prod.yaml -n prod --force
done
