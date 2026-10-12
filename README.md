# Online Boutique - Cloud Native Microservices Full Deployment

![Docker](https://img.shields.io/badge/Docker-Compose-2496ED?logo=docker&logoColor=white)
![Kubernetes](https://img.shields.io/badge/Kubernetes-Manifests-326CE5?logo=kubernetes&logoColor=white)
![Redis](https://img.shields.io/badge/Redis-Persistent%20Storage-DC382D?logo=redis&logoColor=white)
![Architecture](https://img.shields.io/badge/Architecture-11%20Microservices-green)
![CI/CD](https://img.shields.io/badge/CI%2FCD-GitHub%20Actions-2088FF?logo=github-actions&logoColor=white)
![License](https://img.shields.io/badge/License-Apache%202.0-blue)

A complete, self-contained deployment repository for Google's cloud-native **Online Boutique** e-commerce demo application. 

This repository enables a full, turnkey deployment of all **11 polyglot microservices** and persistent **Redis** storage, with support for both local **Docker Compose** orchestration and production **Kubernetes** deployments (Kind, Minikube, GKE, EKS).

---

## 🏛️ System Architecture

```
                       +----------------------------------+
                       |       Client / Browser           |
                       +----------------+-----------------+
                                        |
                                        v HTTP (Port 8080)
                       +----------------------------------+
                       |           Frontend (Go)          |
                       +-------+--------+--------+--------+
                               |        |        |
         +---------------------+        |        +---------------------+
         | gRPC                         | gRPC                         | gRPC
         v                              v                              v
+------------------+          +-------------------+          +-------------------+
|  Ad Service      |          |  Recommendation   |          |  Product Catalog  |
|  (Java)          |          |  (Python)         |          |  (Go)             |
+------------------+          +-------------------+          +-------------------+
                                        |                              |
         +------------------------------+                              |
         | gRPC                                                        | gRPC
         v                                                             v
+------------------+          +-------------------+          +-------------------+
|  Cart Service    |          |  Checkout Service |          |  Currency Service |
|  (C#)            |          |  (Go)             |          |  (Node.js)        |
+--------+---------+          +----+-----+----+---+          +-------------------+
         |                         |     |    |
         v Persistent Storage      |     |    | gRPC
+------------------+               |     |    +--------------+
|  Redis Cart DB   |               |     |                   |
|  (Data Volume)   |               v     v                   v
+------------------+        +---------+ +----------+  +--------------+
                            | Payment | | Shipping |  | Email        |
                            | (Node)  | | (Go)     |  | (Python)     |
                            +---------+ +----------+  +--------------+
```

---

## 📦 Microservices Breakdown

| Service | Language | Port | Protocol | Description |
| :--- | :--- | :--- | :--- | :--- |
| **frontend** | Go | `8080` | HTTP | Serves web UI, manages user sessions and routing. |
| **cartservice** | C# | `7070` | gRPC | Stores items in user shopping cart using Redis. |
| **productcatalogservice** | Go | `3550` | gRPC | Provides product list, details, and search capabilities. |
| **currencyservice** | Node.js | `7000` | gRPC | Converts currency rates based on European Central Bank data. |
| **paymentservice** | Node.js | `50051` | gRPC | Processes credit card transactions (mocked). |
| **shippingservice** | Go | `50051` | gRPC | Calculates shipping rates and generates tracking IDs. |
| **emailservice** | Python | `8080` | gRPC | Sends mock order confirmation emails to users. |
| **checkoutservice** | Go | `5050` | gRPC | Orchestrates payment, shipping, email, and cart clearing. |
| **recommendationservice** | Python | `8080` | gRPC | Recommends related items based on shopping cart context. |
| **adservice** | Java | `9555` | gRPC | Serves contextual text advertisements. |
| **loadgenerator** | Python | — | HTTP | Locust worker generating synthetic user browsing flows. |
| **redis-cart** | Redis | `6379` | TCP | In-memory key-value store with volume persistence. |

---

## ⚡ Deployment Methods

### Option 1: Docker Compose (Quickest Local Run)

Ideal for running all 11 microservices on any machine with Docker installed, without requiring Kubernetes:

1. **Start all services:**
   ```bash
   make up
   # or
   docker compose up -d
   ```

2. **Verify container health and status:**
   ```bash
   make ps
   # or
   docker compose ps
   ```

3. **Access the application:**
   Open [http://localhost:8080](http://localhost:8080) in your browser.

4. **Tear down:**
   ```bash
   make down
   ```

---

### Option 2: Kubernetes (Local or Cloud)

This setup includes individual manifests under `k8s/` and a consolidated `k8s/complete-deployment.yaml`.

#### Key Kubernetes Fix Included
- **PersistentVolumeClaim (PVC)**: Unlike the standard demo which defaults to ephemeral `emptyDir`, this configuration mounts a persistent PVC (`redis-data-pvc`) to `/data` in Redis, preventing user cart data loss across Pod restarts or rescheduling.

1. **Deploy to your Kubernetes cluster:**
   ```bash
   make k8s-apply
   # or
   kubectl apply -f k8s/complete-deployment.yaml
   ```

2. **Monitor Pods and Services:**
   ```bash
   make k8s-status
   # or
   kubectl get pods,svc,pvc
   ```

3. **Port forward the Frontend:**
   ```bash
   make k8s-port-forward
   # or
   kubectl port-forward deployment/frontend 8080:8080
   ```
   Open [http://localhost:8080](http://localhost:8080).

4. **Delete Deployment:**
   ```bash
   make k8s-delete
   ```

---

## 🛠️ Makefile Command Reference

| Command | Action |
| :--- | :--- |
| `make up` | Start all 12 containers via Docker Compose in background |
| `make down` | Stop and remove Compose containers |
| `make ps` | Show Compose container statuses |
| `make logs` | Follow log streams across all services |
| `make k8s-apply` | Apply complete Kubernetes manifests to active cluster |
| `make k8s-delete` | Delete all Kubernetes deployments and services |
| `make k8s-status` | Inspect status of pods, services, and PVCs |
| `make k8s-port-forward` | Forward port 8080 from Kubernetes frontend pod to localhost |
| `make verify` | Run automated HTTP probe script against frontend |
| `make test` | Run dry-run syntax validation on Compose & Kubernetes specs |
| `make clean` | Stop containers and purge volumes |

---

## 🧪 CI/CD & Automated Verification

A GitHub Actions workflow (`.github/workflows/ci.yml`) automatically runs on every push and pull request to ensure:
- Validation of Docker Compose service topology (`docker compose config`).
- Client-side dry-run validation of all Kubernetes manifests (`kubectl apply --dry-run=client`).

To test locally:
```bash
make test
```

---

## 📄 License

This project is licensed under the Apache 2.0 License.
