variable "resource_group_name" {
  description = "Nombre del grupo de recursos"
  type        = string
}

variable "location" {
  description = "Ubicación de los recursos"
  type        = string
}

variable "cluster_name" {
  description = "Nombre del clúster AKS"
  type        = string
}

variable "dns_prefix" {
  description = "Prefijo DNS para el clúster AKS"
  type        = string
}

variable "node_count" {
  description = "Número de nodos en el clúster AKS"
  type        = number
}

variable "vm_size" {
  description = "Tamaño de las VMs en el clúster AKS"
  type        = string
}

variable "tags" {
  description = "Etiquetas para los recursos"
  type        = map(string)
}
