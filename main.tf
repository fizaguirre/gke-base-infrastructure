resource "google_compute_network" "webvpc" {
  name                    = "webvpc"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "gke-subnet" {
  name                     = "gke-subnet"
  network                  = google_compute_network.webvpc.id
  ip_cidr_range            = "10.0.0.0/24"
  purpose                  = "PRIVATE"
  private_ip_google_access = true
}

resource "google_service_account" "appclustersa" {
  account_id   = "appcluster-sa"
  display_name = "App Cluster SA"
}

resource "google_container_cluster" "appcluster" {
  name                     = "appcluster"
  location                 = var.gke_nodepool_location
  initial_node_count       = 1
  remove_default_node_pool = true
  network                  = google_compute_network.webvpc.name
  subnetwork               = google_compute_subnetwork.gke-subnet.self_link
}

resource "google_container_node_pool" "appclusterpool" {
  location           = var.gke_nodepool_location
  initial_node_count = var.gke_nodes_replicas_count
  cluster            = google_container_cluster.appcluster.name
  node_config {
    machine_type    = "g1-small"
    preemptible     = true
    service_account = google_service_account.appclustersa.email
    disk_size_gb    = 20
  }
}

resource "tls_private_key" "app_cert_pk" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "tls_self_signed_cert" "app_cert" {
  allowed_uses          = ["server_auth"]
  dns_names             = [var.cert_cn]
  private_key_pem       = tls_private_key.app_cert_pk.private_key_pem
  validity_period_hours = 720
  subject {
    common_name         = var.cert_cn
    country             = var.cert_country
    locality            = var.cert_locality
    organization        = var.cert_organization
    organizational_unit = var.cert_ou
  }
}

resource "local_file" "app_cert_pk_file" {
  content         = tls_private_key.app_cert_pk.private_key_pem
  filename        = "${abspath(var.app_cert_folder_output)}/app.key"
  file_permission = "0400"
}

resource "local_file" "app_cert_file" {
  content  = tls_self_signed_cert.app_cert.cert_pem
  filename = "${abspath(var.app_cert_folder_output)}/app.crt"
}

resource "null_resource" "get_gke_credentials" {
  depends_on = [google_container_cluster.appcluster]
  provisioner "local-exec" {
    environment = {
      "KUBECONFIG" = var.gke_kubeconfig_path
    }
    command = "gcloud container clusters get-credentials ${google_container_cluster.appcluster.name} --location ${var.gke_nodepool_location}"
  }
}

output "appclusterendpoint" {
  value       = google_container_cluster.appcluster.endpoint
  description = "GKE cluster address"
}

output "gke_info" {
  value = "To interact with the GKE cluster set your the KUBECONFIG environment variable to ${var.gke_kubeconfig_path}, e.g. $ export KUBECONFIG=${var.gke_kubeconfig_path} \nOr to configure your default KUBECONFIG file run: $ gcloud container clusters get-credentials ${google_container_cluster.appcluster.name} --location ${var.gke_nodepool_location}"
}

output "certificates" {
  value = "Self-signed certificates have been created to be used in server's TLS configuration.\nCheck the files at ${var.app_cert_folder_output}"
}

output "_certificate" {
  description = "SSL Certificate in PEM format."
  value       = tls_self_signed_cert.app_cert.cert_pem
}

output "_certificate_key" {
  description = "RSA Private Key that matches the SSL Certificate created in this module"
  value       = tls_private_key.app_cert_pk.private_key_pem
  sensitive   = true
}