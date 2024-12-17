resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = "myAKSCluster"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = "myAKS"

  default_node_pool {
    name       = "default"
    node_count = 2
    vm_size    = "Standard_DS2_v2"
  }

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_api_management_api" "aks_api" {
  name                = "myAKSMicroservicesAPI"
  resource_group_name = azurerm_resource_group.rg.name
  api_management_name = var.apim_name
  revision            = "1"
  display_name        = "AKS Microservices API"
  path                = "aks-microservices"
  protocols           = ["https"]

  import {
    content_format = "swagger-link-json"
    content_value  = "https://myAKSServiceURL/swagger.json"
  }
}
