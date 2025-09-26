# Create Kubernetes namespaces
resource "kubernetes_namespace" "demo" {
  metadata {
    name = "demo"
  }
}

resource "kubernetes_namespace" "openobserve" {
  metadata {
    name = "openobserve"
  }
}

# Locals: split YAML docs in case file has multiple (---)
locals {
  nginx_docs  = [for doc in split("---", file("${path.module}/nginx-deploy.yaml")) : yamldecode(trimspace(doc)) if trimspace(doc) != ""]
  java_docs   = [for doc in split("---", file("${path.module}/my-java-app-deployment.yaml")) : yamldecode(trimspace(doc)) if trimspace(doc) != ""]
  logger_docs = [for doc in split("---", file("${path.module}/logger-app.yaml")) : yamldecode(trimspace(doc)) if trimspace(doc) != ""]
}

# Deploy nginx (all docs inside nginx-deploy.yaml)
resource "kubernetes_manifest" "nginx" {
  for_each   = { for i, v in local.nginx_docs : i => v }
  manifest   = each.value
  depends_on = [kubernetes_namespace.demo]
}

# Deploy java app (all docs inside my-java-app-deployment.yaml)
resource "kubernetes_manifest" "java" {
  for_each   = { for i, v in local.java_docs : i => v }
  manifest   = each.value
  depends_on = [kubernetes_namespace.demo]
}

# Deploy logger app
resource "kubernetes_manifest" "logger" {
  for_each   = { for i, v in local.logger_docs : i => v }
  manifest   = each.value
  depends_on = [kubernetes_namespace.demo]
}

# Helm release for OpenObserve
resource "helm_release" "openobserve" {
  name       = "openobserve-standalone"
  repository = "https://charts.openobserve.ai"
  chart      = "openobserve-standalone"
  namespace  = kubernetes_namespace.openobserve.metadata[0].name
  version    = var.openobserve_chart_version

  values = [
    file("${path.module}/${var.openobserve_values_file}")
  ]

  depends_on = [kubernetes_namespace.openobserve]
}
