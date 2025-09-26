# -----------------------------
# Namespaces
# -----------------------------
resource "kubernetes_namespace" "demo" {
  metadata { name = "demo" }
}
 
resource "kubernetes_namespace" "logger_demo" {
  metadata { name = "logger-demo" }
}
 
resource "kubernetes_namespace" "openobserve" {
  metadata { name = "openobserve" }
}
 
# -----------------------------
# Kubernetes manifests
# -----------------------------
# Function to flatten multiple YAML documents
locals {
  nginx_manifests = flatten([
    for f in fileset("${path.module}/../k8s", "nginx-*.yaml") :
    yamldecodeall(file("${path.module}/../k8s/${f}"))
  ])
 
  java_manifests = flatten([
    for f in fileset("${path.module}/../k8s", "my-java-app-*.yaml") :
    yamldecodeall(file("${path.module}/../k8s/${f}"))
  ])
 
  logger_manifests = flatten([
    for f in fileset("${path.module}/../k8s", "logger-*.yaml") :
    yamldecodeall(file("${path.module}/../k8s/${f}"))
  ])
}
 
resource "kubernetes_manifest" "nginx" {
  for_each   = { for idx, obj in local.nginx_manifests : idx => obj }
  manifest   = each.value
  depends_on = [kubernetes_namespace.demo]
}
 
resource "kubernetes_manifest" "java_app" {
  for_each   = { for idx, obj in local.java_manifests : idx => obj }
  manifest   = each.value
  depends_on = [kubernetes_namespace.demo]
}
 
resource "kubernetes_manifest" "logger_app" {
  for_each   = { for idx, obj in local.logger_manifests : idx => obj }
  manifest   = each.value
  depends_on = [kubernetes_namespace.logger_demo]
}
 
# -----------------------------
# Helm release for OpenObserve
# -----------------------------
resource "helm_release" "openobserve" {
  name       = "openobserve-standalone"
  repository = "https://charts.openobserve.ai"
  chart      = "openobserve-standalone"
  namespace  = kubernetes_namespace.openobserve.metadata[0].name
  version    = "0.2.0"  # update to a valid version
 
  values = [
    file("${path.module}/../helm/openobserve-values.yaml")
  ]
 
  depends_on = [kubernetes_namespace.openobserve]
}
