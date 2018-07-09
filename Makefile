SYSTEM_NAMESPACE = kube-system
TILLER_DEPLOYMENT_YAML = ./dist/tiller-deploy.yaml
MANIFEST_OUTPUT_YAML = ./dist/cluster.yaml
DEFAULT_CERT_ISSUER = letsencrypt-prod
HELM_RELEASES = cert-manager nginx-ingress

cluster : $(HELM_RELEASES) nginx-ingress-ip
	@echo "Cluster is ready!"
tiller-deploy.yaml :
	@hack/generate-tiller-deployment.sh $(TILLER_DEPLOYMENT_YAML)
tiller : tiller-deploy.yaml
	kubectl apply -f $(TILLER_DEPLOYMENT_YAML)
	for i in {1..60}; do helm version --tiller-connection-timeout 2 && break; done
cert-manager : tiller
	helm upgrade --install cert-manager \
		stable/cert-manager \
		--namespace $(SYSTEM_NAMESPACE) \
		--version 0.3.4 \
		--set ingressShim.defaultIssuerName=$(DEFAULT_CERT_ISSUER) \
		--set ingressShim.defaultIssuerKind=ClusterIssuer
	kustomize build ./deploy/cert-manager | kubectl apply -f -
nginx-ingress : tiller
	helm upgrade --install nginx-ingress \
		stable/nginx-ingress \
		--namespace $(SYSTEM_NAMESPACE) \
		--version 0.22.1 \
		--set rbac.create=true
nginx-ingress-ip :
	@hack/print-nginx-ingress-ip.sh $(SYSTEM_NAMESPACE)
ingress-example : nginx-ingress-ip
	kubectl apply -f ./examples/nginx-ingress
manifests :
	kustomize build ./deploy > $(MANIFEST_OUTPUT_YAML)
	kubectl apply -f $(MANIFEST_OUTPUT_YAML)
clean :
	helm del --purge $(HELM_RELEASES)
	kubectl delete -f $(TILLER_DEPLOYMENT_YAML)
	kubectl delete -f ./examples --recursive
