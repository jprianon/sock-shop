#!/bin/bash

aws eks --region eu-west-1 update-kubeconfig --name SockShop-eks --profile sock-shop

service=("ingress")
env=("dev")

helm upgrade --install ingress eks/aws-load-balancer-controller --values=../$service/charts/helm-values/values-$env.yaml \
  -n kube-system \
  --set clusterName=SockShop-eks \
  --set serviceAccount.create=true \
  --set region=eu-west-1 \
  --set vpcId=vpc-0708985fb5c18eb4c \
  --set extraArgs.ingress-class=alb

kubectl apply -f ../$service/charts/templates/deployment.yaml
kubectl apply -f ../$service/charts/templates/service.yaml
kubectl apply -f ../$service/charts/templates/alb_ingress-dev.yaml

#for service in "${service[@]}"; do
#  echo "Déploiement du service $service en dev..."
#  helm upgrade --install $service ../$service/charts --values ../$service/charts/helm-values/values-$env.yaml -n $env --force
#done