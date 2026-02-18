terraform {
  required_version = ">= 1.5.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 5.0"
    }
  }
}

module "vpc" {
  source = "./modules/vpc"

  name    = var.name
  project = var.project_id
  region  = var.region
}

module "gke" {
  source = "./modules/gke"

  name               = var.name
  project            = var.project_id
  region             = var.region
  network            = module.vpc.network_name
  subnetwork         = module.vpc.subnetwork_name
  kubernetes_version = var.kubernetes_version
  machine_type       = var.machine_type
  node_count         = var.node_count
  max_node_count     = var.max_node_count
}

module "cloudsql" {
  source = "./modules/cloudsql"

  name             = var.name
  project          = var.project_id
  region           = var.region
  network_id       = module.vpc.network_id
  tier             = var.db_tier
  disk_size        = var.db_disk_size
  database_version = var.db_version
}
