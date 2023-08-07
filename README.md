## Terraform configuration for setting up a base infrastructure for GKE on GCP

This terraform configuration creates a base infrastructure for a GKE cluster in GCP to run an web application. It includes the following.
* Custom VPC
* Subnet
* Public GKE cluster with configurable number of nodes
* Service account to be used by the GKE cluster nodes
* Server SSL certificates for TLS

A set of variables should be provided for the configuration to run. For simplicity a .tfvars file can be created and used when running terraform.

At the end the Terraform configuration will output some information. The cluster information is included in this output as well as the command you can run to configure kubectl config file to interact with the GKE cluster.