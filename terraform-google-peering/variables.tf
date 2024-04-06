variable "prefixes" {
  description = "Name prefix for the network peerings"
  type        = list(any)
  default     = []
}

variable "local_network" {
  description = "Resource link of the network to add a peering to"
  type        = string
  default     = ""
}

variable "peer_networks" {
  description = "Resource link of the peer network"
  type        = list(any)
  default     = []
}

variable "export_local_custom_routes" {
  description = "Export custom routes to peer network from local network"
  type        = bool
  default     = true
}

variable "export_local_subnet_routes_with_public_ip" {
  description = "Export custom routes to peer network from local network"
  type        = bool
  default     = true
}

variable "export_peer_custom_routes" {
  description = "Export custom routes to local network from peer network"
  type        = bool
  default     = true
}

variable "export_peer_subnet_routes_with_public_ip" {
  description = "Export custom routes to local network from peer network"
  type        = bool
  default     = false
}

