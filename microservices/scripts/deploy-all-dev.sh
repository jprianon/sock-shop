#!/bin/bash

aws eks --region eu-west-1 update-kubeconfig --name SockShop-eks --profile sock-shop

kubectl create namespace dev

# Déploiement des microservices pour l'environnement dev
services=("carts" "catalogue" "front-end" "orders" "paiement" "queue" "rabbitmq" "session" "shipping" "user" "zipkin")

for service in "${services[@]}"; do
  echo "Déploiement du service $service en dev..."
  helm upgrade --install $service ../$service/charts --values ../$service/charts/helm-values/values-dev.yaml -n dev --force
done
