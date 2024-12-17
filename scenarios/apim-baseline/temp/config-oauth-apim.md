Entendido. Vamos a proceder a configurar el API Manager para usar el servidor OAuth2 mediante Terraform. Para ello, vamos a añadir la configuración necesaria en los archivos de Terraform para que el API Manager utilice el servidor OAuth2 desplegado en el clúster AKS.

Paso 1: Añadir Variables Necesarias
Primero, asegúrate de que tienes las variables necesarias en tu archivo variables.tf para la configuración del servidor OAuth2.

Abre el archivo variables.tf y añade las siguientes variables si no están ya presentes:

variable "oauth2_server_url" {
  description = "URL del servidor OAuth2"
  type        = string
}

variable "oauth2_client_id" {
  description = "ID del cliente OAuth2"
  type        = string
}

variable "oauth2_client_secret" {
  description = "Secreto del cliente OAuth2"
  type        = string
}

Paso 2: Configurar el API Manager para Usar el Servidor OAuth2
Vamos a añadir la configuración necesaria en el módulo de API Manager para que utilice el servidor OAuth2.

1. Modificar el Módulo de API Manager
Abre el archivo apim.tf y añade la configuración para el proveedor OAuth2.

resource "azurerm_api_management_identity_provider" "oauth2" {
  api_management_name = azurerm_api_management.apim_internal.name
  resource_group_name = var.resourceGroupName
  type                = "aad"

  client_id     = var.oauth2_client_id
  client_secret = var.oauth2_client_secret

  allowed_tenant_ids = [
    "common"
  ]

  oauth2_authorization_endpoint = "${var.oauth2_server_url}/oauth2/authorize"
  oauth2_token_endpoint         = "${var.oauth2_server_url}/oauth2/token"
  oauth2_redirect_uri           = "${azurerm_api_management.apim_internal.gateway_url}/signin-oauth"
}

2. Añadir la Configuración de Seguridad en el API Manager
Abre el archivo apim.tf y añade la configuración de seguridad para las APIs que utilizarán el servidor OAuth2.

resource "azurerm_api_management_api" "example_api" {
  name                = "example-api"
  resource_group_name = var.resourceGroupName
  api_management_name = azurerm_api_management.apim_internal.name
  revision            = "1"
  display_name        = "Example API"
  path                = "example"
  protocols           = ["https"]
  service_url         = "http://example-service"

  authentication_settings {
    o_auth2 {
      authorization_server_id = azurerm_api_management_identity_provider.oauth2.id
      scope                   = "api.read"
    }
  }

  lifecycle {
    prevent_destroy = true
  }
}

Paso 3: Invocar el Módulo de API Manager desde main.tf
Asegúrate de que el módulo de API Manager está invocado correctamente en el archivo main.tf.

Abre el archivo main.tf y verifica que el módulo de API Manager está configurado correctamente.

module "apim" {
  depends_on              = [module.shared, module.networking]
  source                  = "./modules/apim"
  location                = var.location
  resourceGroupName       = azurerm_resource_group.apim.name
  resourceSuffix          = local.resourceSuffix
  environment             = var.environment
  apimSubnetId            = module.networking.apimSubnetId
  instrumentationKey      = module.shared.instrumentationKey
  workspaceId             = module.shared.workspaceId
  sharedResourceGroupName = azurerm_resource_group.shared.name
  keyVaultName            = local.keyVaultName

  oauth2_server_url       = var.oauth2_server_url
  oauth2_client_id        = var.oauth2_client_id
  oauth2_client_secret    = var.oauth2_client_secret
}

Resumen
Añadir Variables Necesarias: Añadir variables para la configuración del servidor OAuth2 en variables.tf.
Configurar el API Manager para Usar el Servidor OAuth2: Añadir la configuración necesaria en el módulo de API Manager (modules/apim/apim.tf) para que utilice el servidor OAuth2.
Invocar el Módulo de API Manager desde main.tf: Asegurarse de que el módulo de API Manager está invocado correctamente en main.tf.
Con estos cambios, el API Manager estará configurado para utilizar el servidor OAuth2 desplegado en el clúster AKS. Si necesitas más detalles o pasos adicionales, por favor házmelo saber.
