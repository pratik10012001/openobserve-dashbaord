# Namespaces
output "namespaces" {
  value = [
    kubernetes_namespace.demo.metadata[0].name,
    kubernetes_namespace.openobserve.metadata[0].name
  ]
}

# Output nginx manifests applied
output "nginx_objects" {
  value = { for k, v in kubernetes_manifest.nginx : k => v.object }
}

output "java_objects" {
  value = { for k, v in kubernetes_manifest.java_app : k => v.object }
}
 
output "logger_objects" {
  value = { for k, v in kubernetes_manifest.logger_app : k => v.object }
}

# Helm release info
output "openobserve_release" {
  value = helm_release.openobserve.status
}
