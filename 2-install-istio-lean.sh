#!/usr/bin/env bash

set -x

# Create CRDs
kubectl apply -f https://raw.githubusercontent.com/knative/serving/release-0.10/third_party/istio-1.3.3/istio-crds.yaml

# Wait until CRDs are created
kubectl wait --for=condition=complete job/istio-init-crd-10-1.3.3 -n istio-system --timeout=60s
kubectl wait --for=condition=complete job/istio-init-crd-11-1.3.3 -n istio-system --timeout=60s
kubectl wait --for=condition=complete job/istio-init-crd-12-1.3.3 -n istio-system --timeout=60s

# Deploy istio
kubectl apply -f https://raw.githubusercontent.com/knative/serving/release-0.10/third_party/istio-1.3.3/istio-lean.yaml

# Reduce resource consumption
kubectl patch hpa istio-ingressgateway --patch '{"spec":{"minReplicas":1}}' -n istio-system
kubectl scale --replicas=1 deployment/cluster-local-gateway -n istio-system
kubectl scale --replicas=1 deployment/istio-pilot -n istio-system
kubectl scale --replicas=1 deployment/istio-ingressgateway -n istio-system

# Adjust port to match port forwarding on host 
kubectl patch service istio-ingressgateway --namespace=istio-system --type='json' --patch='[{"op": "replace", "path": "/spec/ports/1/nodePort", "value":32000}]'

#Wait for deployment to finish
kubectl rollout status -w deployment/cluster-local-gateway -n istio-system
kubectl rollout status -w deployment/istio-ingressgateway  -n istio-system
kubectl rollout status -w deployment/istio-pilot -n istio-system
set +x

# Info
echo 
kubectl get pods -n istio-system
echo
echo "Istio deployed"
echo

