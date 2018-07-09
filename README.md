# kubernetes-provision
Provision and configure kubernetes clusters

## Prerequisites
You will need the following tools installed:
  - [Make](https://www.gnu.org/software/make/)
  - [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
  - [helm client](https://docs.helm.sh/using_helm/#installing-the-helm-client)
  - [kustomize](https://github.com/kubernetes-sigs/kustomize)

In addition, you will need access to a running kubernetes cluster.
<!-- TODO: automate cluster provisioning -->

## Usage
### Configure a cluster
```bash
make cluster
```

Pay attention to the console output -- you will need to configure an external DNS provider to point to the NGINX ingress controller IP in order for ingress resources to work.

Given the output
```
NGINX ingress IP is set to XX.XXX.XX.XX
```

You could add a DNS `A` record for `*.my-cluster.example.com` pointing to `XX.XXX.XX.XX`. This would allow an ingress resource referencing the host `my-app.my-cluster.example.com` to route traffic.

### Create an example ingress
```bash
make ingress-example
```

### Return cluster to original state
```bash
make clean
```
