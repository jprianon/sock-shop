#!/bin/bash
echo "Entered the Deployment phase..."
echo "Deployment started on $(date)"
helm list -n ${ENVIRONMENT}
helm upgrade --install spring-api-gateway-${ENVIRONMENT} charts/ --values charts/helm_values/values-${ENVIRONMENT}.yaml -n ${ENVIRONMENT}
