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
 
# Deploy nginx
resource "kubernetes_manifest" "nginx" {
  manifest   = yamldecode(file("${path.module}/../k8s/nginx-deploy.yaml"))
  depends_on = [kubernetes_namespace.demo]
}
 
# Deploy java app
resource "kubernetes_manifest" "java" {
  manifest   = yamldecode(file("${path.module}/../k8s/my-java-app-deployment.yaml"))
  depends_on = [kubernetes_namespace.demo]
}
 
# Deploy logger app
resource "kubernetes_manifest" "logger" {
  manifest   = yamldecode(file("${path.module}/../k8s/logger-app.yaml"))
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
