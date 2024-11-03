#!/bin/bash
echo "Deployment to EKS COMPLETED on $(date)"
echo "If API gateway is deployed, try this URL:"
URL=$(kubectl get ingress -n ${ENVIRONMENT} | awk '{print $3}' | tail -n +2)
echo "URL: http://${URL}"

response=$(curl -Is https://www-${ENVIRONMENT}.vetops.net/api/gateway/owners/0)
http_status=$(echo "${response}" | head -n 1 | awk '{print $2}')

if [ "$http_status" -eq 200 ]; then
    echo "The request succeeded with HTTP response code 200 (OK)"
else
    echo "The request failed with HTTP response code ${http_status}"
fi
