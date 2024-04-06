# Google peering
This module creates peering between your vpcs

# Example terragrunt.hcl usage
```hcl
terraform {
  source = "https://gitlab.com/MyRepo/applications/devops/tf-modules.git//terraform-google-peering"
}

inputs = merge(local.resource_vars["inputs"], {
  environment       = local.environment
  host_project_name = dependency.net-vpc.outputs.project_id
  network_name      = dependency.net-vpc.outputs.network_name
  subnets           = dependency.net-vpc.outputs.subnets
  local_network     = dependency.net-vpc.outputs.network_self_link
  peer_networks      = [
    dependency.dev-vpc.outputs.network_self_link,
    dependency.stage-vpc.outputs.network_self_link
  ]
})

locals {
  common_vars   = yamldecode(file(find_in_parent_folders("${local.environment}.yaml")))
  environment   = basename(dirname(get_terragrunt_dir()))
  resource      = basename(get_terragrunt_dir())
  resource_vars = local.common_vars["Resources"]["${local.resource}"]
}

dependency "admin" {
  config_path = "../../Core/admin"
}

dependency "net-vpc" {
  config_path = "../net-vpc"
}

dependency "dev-vpc" {
  config_path = "../../Dev/net-vpc"
}

dependency "stage-vpc" {
  config_path = "../../Stage/net-vpc"
}

include {
  path = find_in_parent_folders()
}
```

# Vars file
You will need to add some basic vars and naming for peering module into var.yaml
```
net-peering:
  inputs:
    billing_account: *billing_account
    domain: *domain
    prefixes: 
      - "peering-infra-dev"
      - "peering-infra-stage"
```

[^]: (autogen_docs_start)
## Requirements

No requirements.

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_peerings"></a> [peerings](#module\_peerings) | terraform-google-modules/network/google//modules/network-peering | 4.0.1 |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_export_local_custom_routes"></a> [export\_local\_custom\_routes](#input\_export\_local\_custom\_routes) | Export custom routes to peer network from local network | `bool` | `true` | no |
| <a name="input_export_local_subnet_routes_with_public_ip"></a> [export\_local\_subnet\_routes\_with\_public\_ip](#input\_export\_local\_subnet\_routes\_with\_public\_ip) | Export custom routes to peer network from local network | `bool` | `true` | no |
| <a name="input_export_peer_custom_routes"></a> [export\_peer\_custom\_routes](#input\_export\_peer\_custom\_routes) | Export custom routes to local network from peer network | `bool` | `true` | no |
| <a name="input_export_peer_subnet_routes_with_public_ip"></a> [export\_peer\_subnet\_routes\_with\_public\_ip](#input\_export\_peer\_subnet\_routes\_with\_public\_ip) | Export custom routes to local network from peer network | `bool` | `false` | no |
| <a name="input_local_network"></a> [local\_network](#input\_local\_network) | Resource link of the network to add a peering to | `string` | `""` | no |
| <a name="input_peer_networks"></a> [peer\_networks](#input\_peer\_networks) | Resource link of the peer network | `list(any)` | `[]` | no |
| <a name="input_prefixes"></a> [prefixes](#input\_prefixes) | Name prefix for the network peerings | `list(any)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_peerings"></a> [peerings](#output\_peerings) | n/a |

[^]: (autogen_docs_end)
