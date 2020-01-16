#!/usr/bin/env bash
cd $(dirname ${BASH_SOURCE})

CLUSTER_NAME=${CLUSTER_NAME:=knative}
KIND=$(which kind)
if [ -z $KIND ]; then
	KIND=.bin/kind
fi
if [ ! -f $KIND ]; then
	curl -Lo ./.bin/kind "https://github.com/kubernetes-sigs/kind/releases/download/v0.7.0/kind-$(uname)-amd64" --create-dirs
	chmod +x ./.bin/kind
fi
set -x

$KIND delete cluster --name ${CLUSTER_NAME}

$KIND create cluster --image kindest/node:v1.16.1 --name ${CLUSTER_NAME} --config kind-config.yaml
kubectl cluster-info

# Reduce resource consumption
kubectl scale --replicas=1 deployment/coredns -n kube-system

#Wait until node is ready
kubectl wait --for=condition=Ready node/knative-control-plane --timeout=180s
set +x

# Info
echo
kubectl get nodes 
echo
echo "Cluster created"
echo 
