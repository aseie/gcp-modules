module "peerings" {
  for_each = zipmap(var.prefixes, var.peer_networks)

  source                                    = "terraform-google-modules/network/google//modules/network-peering"
  version                                   = "~> 7.1"
  prefix                                    = each.key
  local_network                             = var.local_network
  peer_network                              = each.value
  export_local_custom_routes                = var.export_local_custom_routes
  export_peer_custom_routes                 = var.export_peer_custom_routes
  export_local_subnet_routes_with_public_ip = var.export_local_subnet_routes_with_public_ip
  export_peer_subnet_routes_with_public_ip  = var.export_peer_subnet_routes_with_public_ip
}
