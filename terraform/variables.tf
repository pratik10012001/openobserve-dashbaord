variable "namespaces" {
  type        = list(string)
  default     = ["demo", "openobserve"]
  description = "Namespaces to create in Kubernetes"
}

variable "openobserve_chart_version" {
  type        = string
  default     = "0.1.0" # replace with latest stable
  description = "OpenObserve Helm chart version"
}

variable "openobserve_values_file" {
  type        = string
  default     = "openobserve-values.yaml"
  description = "Custom values.yaml for OpenObserve Helm chart"
}
