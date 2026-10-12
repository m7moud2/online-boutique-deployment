#!/usr/bin/env bash
set -e

CLUSTER_NAME="boutique-cluster"

echo "Creating local Kind cluster: $CLUSTER_NAME..."
if kind get clusters | grep -q "^$CLUSTER_NAME$"; then
    echo "Cluster $CLUSTER_NAME already exists."
else
    kind create cluster --name "$CLUSTER_NAME"
fi

echo "Applying Kubernetes manifests with Redis PVC..."
kubectl apply -f k8s/complete-deployment.yaml

echo "Waiting for pods to be ready..."
kubectl wait --for=condition=ready pod -l app=frontend --timeout=180s || true

echo "Cluster ready! To access frontend run:"
echo "kubectl port-forward deployment/frontend 8080:8080"
