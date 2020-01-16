#!/usr/bin/env bash

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

$KIND delete cluster --name="${CLUSTER_NAME}"
