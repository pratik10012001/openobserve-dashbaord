# openobserve-dashbaord

# Kubernetes + OpenObserve + Terraform + CI/CD (Demo)

## Overview
This repo demonstrates a single-node k3s Kubernetes cluster on EC2, OpenObserve deployment (Helm), Terraform-managed infra, and a GitHub Actions pipeline.

## Quickstart (on EC2)
1. Clone repo
2. Install k3s: `curl -sfL https://get.k3s.io | sh -`
3. Install helm & kubectl (see scripts)
4. Run `terraform init && terraform apply -auto-approve` in `terraform/`
5. Port-forward OpenObserve: `kubectl -n openobserve port-forward svc/openobserve-standalone 5080:5080`
6. ssh -i pratik-test-rd.pem -L 5080:localhost:5080 ubuntu@3.91.201.57
7. Open `http://localhost:5080` and check logs from `logger-demo` namespace.

## CI/CD
- Jenkins pipline`.

## Validation
- kubectl get pods --all-namespaces
- In OpenObserve UI, filter logs: `level="ERROR"`

## Notes
- This demo uses `openobserve-standalone` for local testing (persistence disabled).
