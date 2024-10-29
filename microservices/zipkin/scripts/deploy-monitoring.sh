#!/bin/bash
cd ../monitoring
kubectl create namespace monitoring                 
kubectl create -f 00-monitoring-ns.yaml
kubectl apply $(ls *-prometheus-*.yaml | awk ' { print " -f " $1 } ')
kubectl apply $(ls *-grafana-*.yaml | awk ' { print " -f " $1 }'  | grep -v grafana-import)