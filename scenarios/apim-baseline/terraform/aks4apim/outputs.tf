output "aks_cluster_id" {
  value = azurerm_kubernetes_cluster.aks.id
}

output "apim_api_id" {
  value = azurerm_api_management_api.aks_api.id
}
