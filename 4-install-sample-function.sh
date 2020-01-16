#!/usr/bin/env bash

set -x
kubectl apply --filename hello-function.yaml

# Wait for image pull
kubectl wait --for=condition=Ready ksvc/hello --timeout=180s
set +x

# Info
echo 
kubectl get ksvc
echo
echo "Sample function deployed"
echo
set -x
curl http://hello.default.127.0.0.1.nip.io
