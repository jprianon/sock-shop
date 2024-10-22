#!/bin/bash

# Add the EKS Helm repo
#helm repo add eks https://aws.github.io/eks-charts

# Update Helm repos
#helm repo update

# Install the AWS Load Balancer Controller using Helm
helm upgrade --install aws-load-balancer-controller-2 eks/aws-load-balancer-controller --values=values.yaml \
  -n kube-system \
  --set clusterName=SockShop-eks \
  --set serviceAccount.create=true \
  --set region=eu-west-1 \
  --set vpcId=vpc-0708985fb5c18eb4c \
  --set extraArgs.ingress-class=alb