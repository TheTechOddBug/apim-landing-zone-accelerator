variable "resource_group_name" {
  description = "Nombre del grupo de recursos"
  default     = "myResourceGroup"
}

variable "location" {
  description = "Región de Azure"
  default     = "eastus"
}

variable "apim_name" {
  description = "Nombre del APIM existente"
  default     = "myAPIMInstance"
}
