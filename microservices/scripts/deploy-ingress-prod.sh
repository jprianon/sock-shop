#!/bin/bash

aws eks --region eu-west-1 update-kubeconfig --name SockShop-eks --profile sock-shop

service=("ingress")
env=("prod")

helm upgrade --install ingress eks/aws-load-balancer-controller --values=../$service/charts/helm-values/values-$env.yaml \
  -n kube-system \
  --set clusterName=SockShop-eks \
  --set serviceAccount.create=true \
  --set region=eu-west-1 \
  --set vpcId=vpc-0708985fb5c18eb4c \
  --set extraArgs.ingress-class=alb

kubectl apply -f ../$service/charts/templates/deployment-$env.yaml
kubectl apply -f ../$service/charts/templates/service-$env.yaml
kubectl apply -f ../$service/charts/templates/alb_ingress-$env.yaml

#for service in "${service[@]}"; do
#  echo "Déploiement du service $service en prod..."
#  helm upgrade --install $service ../$service/charts --values ../$service/charts/helm-values/values-$env.yaml -n $env --force
#done