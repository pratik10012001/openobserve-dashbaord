 resource "kubernetes_namespace" "demo" {
  metadata { name = "demo" }
}
 
resource "kubernetes_namespace" "logger_demo" {
  metadata { name = "logger-demo" }
}
 
resource "kubernetes_namespace" "openobserve" {
  metadata { name = "openobserve" }
}
 
# Example for single YAML per manifest
resource "kubernetes_manifest" "nginx" {
  for_each = fileset("${path.module}/../k8s", "nginx-*.yaml")
  manifest = yamldecode(file("${path.module}/../k8s/${each.key}"))
  depends_on = [kubernetes_namespace.demo]
}
 
resource "kubernetes_manifest" "java_app" {
  for_each = fileset("${path.module}/../k8s", "my-java-app-*.yaml")
  manifest = yamldecode(file("${path.module}/../k8s/${each.key}"))
  depends_on = [kubernetes_namespace.demo]
}
 
resource "kubernetes_manifest" "logger_app" {
  for_each = fileset("${path.module}/../k8s", "logger-*.yaml")
  manifest = yamldecode(file("${path.module}/../k8s/${each.key}"))
  depends_on = [kubernetes_namespace.logger_demo]
}
 
resource "helm_release" "openobserve" {
  name       = "openobserve-standalone"
  repository = "https://charts.openobserve.ai"
  chart      = "openobserve-standalone"
  namespace  = kubernetes_namespace.openobserve.metadata[0].name
  version    = "0.2.0"  # validate version
 
  values = [
    file("${path.module}/../helm/openobserve-values.yaml")
  ]
 
  depends_on = [kubernetes_namespace.openobserve]
}
