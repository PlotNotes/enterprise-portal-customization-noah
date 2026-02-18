variable "name" {
  description = "Name prefix for all resources"
  type        = string
  default     = "chartsmith"
}

variable "project_id" {
  description = "GCP project ID"
  type        = string
}

variable "region" {
  description = "GCP region"
  type        = string
  default     = "us-central1"
}

variable "kubernetes_version" {
  description = "GKE Kubernetes version"
  type        = string
  default     = "1.29"
}

variable "machine_type" {
  description = "GCE machine type for GKE nodes"
  type        = string
  default     = "e2-standard-4"
}

variable "node_count" {
  description = "Number of GKE nodes per zone"
  type        = number
  default     = 1
}

variable "max_node_count" {
  description = "Maximum number of GKE nodes per zone"
  type        = number
  default     = 3
}

variable "db_tier" {
  description = "Cloud SQL instance tier"
  type        = string
  default     = "db-custom-4-16384"
}

variable "db_disk_size" {
  description = "Cloud SQL disk size in GB"
  type        = number
  default     = 100
}

variable "db_version" {
  description = "Cloud SQL PostgreSQL version"
  type        = string
  default     = "POSTGRES_15"
}
