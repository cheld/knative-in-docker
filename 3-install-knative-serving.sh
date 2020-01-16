#!/usr/bin/env bash


KNATIVE_VERSION=${KNATIVE_VERSION:="0.10.0"}

set -x
kubectl apply --filename https://github.com/knative/serving/releases/download/v${KNATIVE_VERSION}/serving-crds.yaml

sleep 3
kubectl apply --filename https://github.com/knative/serving/releases/download/v${KNATIVE_VERSION}/serving-crds.yaml
sleep 3


kubectl apply \
--selector networking.knative.dev/certificate-provider!=cert-manager \
--filename https://github.com/knative/serving/releases/download/v${KNATIVE_VERSION}/serving.yaml
sleep 5

kubectl apply \
--selector networking.knative.dev/certificate-provider!=cert-manager \
--filename https://github.com/knative/serving/releases/download/v${KNATIVE_VERSION}/serving.yaml

#Wait for deployment to finish
kubectl rollout status -w deployment/activator -n knative-serving
kubectl rollout status -w deployment/autoscaler  -n knative-serving
kubectl rollout status -w deployment/autoscaler-hpa  -n knative-serving
kubectl rollout status -w deployment/controller -n knative-serving
kubectl rollout status -w deployment/networking-istio  -n knative-serving
kubectl rollout status -w deployment/webhook -n knative-serving

DOMAIN="127.0.0.1.nip.io"
echo "Setting up local domain ${DOMAIN}"
kubectl patch configmap -n knative-serving config-domain -p "{\"data\": {\"${DOMAIN}\": \"\"}}"
set +x

# Info
echo 
kubectl get pods --namespace knative-serving
echo
echo "Knative serving deployed"
echo

