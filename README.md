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
```bash
git clone https://github.com/Skookum/kubernetes-provision.git --recurse-submodules
cd kubernetes-provision
```

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

### Deploy Jenkins
You will need a valid Github application client ID and secret to be used with the [Github OAuth Plugin](https://wiki.jenkins.io/display/JENKINS/GitHub+OAuth+Plugin).

Ask @markflowers if you need credentials for the Github app that has been configured for jenkins.k8s.skookum.com.
```bash
export GITHUB_AUTH_CLIENT_ID=foo
export GITHUB_AUTH_CLIENT_SECRET=bar
make jenkins
```
