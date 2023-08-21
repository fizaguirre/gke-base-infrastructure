variable "gcp_project" {
  type        = string
  description = "GCP Project ID"
}

variable "gcp_region" {
  type        = string
  description = "GCP Region ID"
}

variable "gke_nodepool_location" {
  type        = string
  description = "GKE node pool location can be either a Region or a Zone"
}

variable "gke_kubeconfig_path" {
  type        = string
  description = "Path to the KUBECONFIG file"
  default     = "../shared-outputs/"
}

variable "app_cert_folder_output" {
  type        = string
  description = "Folder to output the Server SSL certificate"
}

variable "gke_nodes_replicas_count" {
  description = "Number of nodes in the GKE node pool"
}

#The following variables sets SSL certificate attributes
variable "cert_cn" {
  type = string
}

variable "cert_organization" {
  type = string
}

variable "cert_country" {
  type = string
}

variable "cert_locality" {
  type = string
}

variable "cert_ou" {
  type = string
}