# Online Boutique Deployment

A local deployment setup for Google's Online Boutique microservices application using Docker Compose and Kubernetes.

## Overview

Online Boutique is an e-commerce demo application made of 11 microservices and a Redis database. This repository contains the configurations to run all services locally using Docker Compose or on a Kubernetes cluster.

### Services List
- **frontend:** Web UI written in Go (port 8080)
- **cartservice:** Shopping cart service written in C# (port 7070)
- **productcatalogservice:** Product catalog service written in Go (port 3550)
- **currencyservice:** Currency conversion service written in Node.js (port 7000)
- **paymentservice:** Mock payment service written in Node.js (port 50051)
- **shippingservice:** Shipping cost calculation in Go (port 50051)
- **emailservice:** Order confirmation email service in Python (port 8080)
- **checkoutservice:** Checkout flow coordinator in Go (port 5050)
- **recommendationservice:** Product recommendation service in Python (port 8080)
- **adservice:** Ad server in Java (port 9555)
- **loadgenerator:** Traffic generator tool in Python
- **redis-cart:** Redis database for cart data storage

---

## How to Run

### 1. Using Docker Compose

To start all services locally with Docker Compose:

```bash
docker compose up -d
```

Check the status of running containers:
```bash
docker compose ps
```

Open your browser and visit:
```
http://localhost:8080
```

To stop all containers:
```bash
docker compose down
```

---

### 2. Using Kubernetes

All Kubernetes manifests are located in the `k8s/` directory.

To deploy all services to an active cluster:
```bash
kubectl apply -f k8s/complete-deployment.yaml
```

Check pods and services status:
```bash
kubectl get pods
kubectl get svc
```

Access the frontend via port forwarding:
```bash
kubectl port-forward deployment/frontend 8080:8080
```
Then open `http://localhost:8080` in your browser.

To delete the deployment:
```bash
kubectl delete -f k8s/complete-deployment.yaml
```

---

## Notes on the Setup

- **Persistent Cart Storage:** In `k8s/redis.yaml`, a `PersistentVolumeClaim` (PVC) named `redis-data-pvc` is configured and mounted to `/data` instead of using `emptyDir`. This keeps user cart items saved if the Redis pod restarts.
- **Docker Compose Networking:** All services communicate through a custom bridge network (`boutique_net`) using Docker internal DNS names (for example, `cartservice:7070` and `redis-cart:6379`).

---

## Helper Commands (Makefile)

A Makefile is included for quick shortcuts:

- `make up` - Start containers using Docker Compose
- `make down` - Stop containers
- `make ps` - Check container status
- `make k8s-apply` - Deploy manifests to Kubernetes
- `make k8s-delete` - Remove Kubernetes resources
- `make k8s-port-forward` - Port-forward frontend service to localhost:8080
- `make verify` - Run the bash health check script

---

## License
Apache 2.0
