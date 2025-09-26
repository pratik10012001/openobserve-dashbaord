terraform {
  required_version = ">= 1.5.0"

  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.20"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.10"
    }
  }
}

# Kubernetes provider (reads from ~/.kube/config or env vars)
provider "kubernetes" {
  config_path = "~/.kube/config"
}

# Helm provider (also uses kubeconfig)
provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}
