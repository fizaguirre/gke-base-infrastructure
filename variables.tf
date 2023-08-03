variable "gcp_project" {
  type = string
}

variable "gcp_region" {
  type = string
}

variable "gke_nodepool_location" {
  type = string
}

variable "app_cert_folder_output" {
  type = string
}

variable "gke_nodes_replicas_count" {}

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