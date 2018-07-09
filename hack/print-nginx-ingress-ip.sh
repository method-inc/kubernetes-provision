#!/bin/bash

NAMESPACE=$1

function get-ip() {
	echo "Getting ingress controller IP... next retry $1 seconds"
	INGRESS_IP=$(kubectl get svc nginx-ingress-controller \
		-n $NAMESPACE \
		-o jsonpath='{.status.loadBalancer.ingress[0].ip}')
}

NEXT_WAIT_TIME=0
until [ ! -z "$INGRESS_IP" ] || [ $NEXT_WAIT_TIME -eq 30 ]; do
	get-ip $NEXT_WAIT_TIME
  sleep $(( NEXT_WAIT_TIME++ ))
done

echo "NGINX ingress IP is set to $INGRESS_IP"
