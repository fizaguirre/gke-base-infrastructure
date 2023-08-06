## Terraform configuration for setting up a base infrastructure for GKE on GCP

This terraform configuration creates a base infrastructure for a GKE cluster in GCP to run an web application. It includes the following.
* VPC
* Subnet
* GKE cluster with configurable number of nodes
* Server SSL certificates for TLS

A set of variables should be provided for the configuration to run. For simplicity create a .tfvars file and use it when running terraform.

At the end the Terraform configuration will output some information. The cluster information is included in this output with the command you can run to configure your kubectl config file to interact with the GKE cluster.