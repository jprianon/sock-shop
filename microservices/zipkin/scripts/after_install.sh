#!/bin/bash
echo "Install completed on $(date)"
echo "Connecting to EKS cluster: ${CLUSTER_NAME}"
aws eks update-kubeconfig --region ${REGION} --name ${CLUSTER_NAME}

echo "Checking if Kubernetes namespace exists (${ENVIRONMENT})"
if kubectl get namespaces | grep ${ENVIRONMENT}; then
    echo "Namespace ${ENVIRONMENT} exists."
else
    echo "Namespace ${ENVIRONMENT} does not exist. Creating it..."
    kubectl create namespace ${ENVIRONMENT}
fi
