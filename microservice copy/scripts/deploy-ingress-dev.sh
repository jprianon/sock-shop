#!/bin/bash

aws eks --region eu-west-1 update-kubeconfig --name SockShop-eks --profile sock-shop

services=("ingress")
env=("dev")

kubectl apply -f ../$services/charts/templates/clusterrole.yaml
kubectl apply -f ../$services/charts/templates/clusterrolebinding.yaml


helm upgrade --install ingress eks/aws-load-balancer-controller --values=../$services/charts/helm-values/values-$env.yaml \
  -n kube-system \
  --set clusterName=SockShop-eks \
  --set serviceAccount.create=true \
  --set region=eu-west-1 \
  --set vpcId=vpc-0708985fb5c18eb4c \
  --set extraArgs.ingress-class=alb

kubectl create namespace $services

# Déploiement des microservices pour l'environnement dev

sleep 20

for service in "${services[@]}"; do
  echo "Déploiement du service $services en dev..."
  helm upgrade --install $services ../$services/charts --values ../$services/charts/helm-values/values-$env.yaml -n $env --force
done
