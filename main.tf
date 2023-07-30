resource "google_compute_network" "webvpc" {
  name                    = "webvpc"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "publicnet" {
  name          = "publicnet"
  network       = google_compute_network.webvpc.id
  ip_cidr_range = "10.0.0.0/24"
}

resource "google_compute_subnetwork" "privatenet" {
  name                     = "privatenet"
  network                  = google_compute_network.webvpc.id
  ip_cidr_range            = "10.1.0.0/24"
  purpose                  = "PRIVATE"
  private_ip_google_access = true
}

resource "google_service_account" "appclustersa" {
  account_id   = "appcluster-sa"
  display_name = "App Cluster SA"
}

resource "google_container_cluster" "appcluster" {
  name                     = "appcluster"
  location                 = "us-central1-a"
  initial_node_count       = 1
  remove_default_node_pool = true
  network                  = google_compute_network.webvpc.name
  subnetwork               = google_compute_subnetwork.privatenet.self_link
  /*   private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = true
    master_ipv4_cidr_block = "192.168.254.0/28"
  } */
}

resource "google_container_node_pool" "appclusterpool" {
  location           = var.gke_nodepool_zone
  initial_node_count = 1
  cluster            = google_container_cluster.appcluster.name
  node_config {
    machine_type    = "g1-small"
    preemptible     = true
    service_account = google_service_account.appclustersa.email
  }
}


output "appclusterendpoint" {
  value       = google_container_cluster.appcluster.endpoint
  description = "GKE cluster address"
}

output "gke_info" {
  value = "In order to interact with the GKE cluster make sure to get your credentials configured on the kubeconfig file. \n To get the GKE credentials run: gcloud container clusters get-credentials ${google_container_cluster.appcluster.name} --zone ${var.gke_nodepool_zone}"
}