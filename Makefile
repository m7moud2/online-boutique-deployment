.PHONY: up down restart ps logs k8s-apply k8s-delete k8s-status verify test clean

# Docker Compose Commands
up:
	docker compose up -d

down:
	docker compose down

restart:
	docker compose restart

ps:
	docker compose ps

logs:
	docker compose logs -f

# Kubernetes Commands
k8s-apply:
	kubectl apply -f k8s/complete-deployment.yaml

k8s-delete:
	kubectl delete -f k8s/complete-deployment.yaml

k8s-status:
	kubectl get pods,svc,pvc -l app=frontend -o wide
	kubectl get pods,svc,pvc

k8s-port-forward:
	kubectl port-forward deployment/frontend 8080:8080

# Verification & Health
verify:
	./scripts/verify-health.sh

test:
	docker compose config
	kubectl apply --dry-run=client -f k8s/complete-deployment.yaml

clean:
	docker compose down -v --remove-orphans
