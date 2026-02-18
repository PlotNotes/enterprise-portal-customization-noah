output "cluster_name" {
  description = "AKS cluster name"
  value       = module.aks.cluster_name
}

output "cluster_fqdn" {
  description = "AKS cluster FQDN"
  value       = module.aks.cluster_fqdn
}

output "database_fqdn" {
  description = "PostgreSQL Flexible Server FQDN"
  value       = module.postgresql.fqdn
}

output "database_connection_string" {
  description = "Full PostgreSQL connection string for ChartSmith Helm values"
  value       = module.postgresql.connection_string
  sensitive   = true
}

output "resource_group_name" {
  description = "Resource group name"
  value       = azurerm_resource_group.main.name
}

output "kubeconfig_command" {
  description = "Command to configure kubectl"
  value       = "az aks get-credentials --resource-group ${azurerm_resource_group.main.name} --name ${module.aks.cluster_name}"
}
