provider "google" {
  project = var.gcp_project
  region  = var.gcp_region
}

terraform {
  required_providers {
    tls = {
      source = "hashicorp/tls"
      version = "4.0.4"
    }
  }
}