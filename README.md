# Knative in Docker

Install Knative in a docker container. Intended for developing and testing purposes


## Prerequisites

Install the following software:
* [Docker](https://docs.docker.com/install/)
* [Kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/#install-kubectl)



## Install Knative

Install the full stack with a single command:
```
./1-create-kubernetes-cluster.sh && \
./2-install-istio-lean.sh && \
./3-install-knative-serving.sh && \
./4-install-sample-function.sh
```

Try to invoke the sample function
```
curl http://hello.default.127.0.0.1.nip.io
```

Clean up with:
```
./5-delete-cluster.sh
```

