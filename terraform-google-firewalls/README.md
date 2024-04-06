# firewall
This module creates firewall rules.

# Example terragrunt.hcl usage
```hcl
dependency "cluster_network" {
  config_path = "../net-vpc"
}

inputs = {
  firewalls = {
    ssh-web = {
      network_name = dependency.cluster_network.outputs.network_name
      project_id   = dependency.cluster_network.outputs.project_id
      allow = [
        {
          protocol = "tcp"
          ports = ["22", "80"]
        }
      ]
      deny                    = []
      destination_ranges      = null
      source_ranges           = ["0.0.0.0/0"]
      direction               = "INGRESS"
      disabled                = false
      priority                = 900
      source_service_accounts = null
      source_tags             = null
      target_service_accounts = null
      target_tags             = null
      log_config              = []
    }
  }
}
```

[^]: (autogen_docs_start)
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google_compute_firewall.firewalls](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_firewall) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_firewalls"></a> [firewalls](#input\_firewalls) | Mapping of firewall rules. Key = firewall name, Value = firewall config | <pre>map(object({<br>    network    = string<br>    project_id = string<br>    allow = list(object({<br>      protocol = string,<br>      ports    = list(string)<br>    }))<br>    deny = list(object({<br>      protocol = string,<br>      ports    = string<br>    }))<br>    destination_ranges      = set(string)<br>    source_ranges           = set(string)<br>    direction               = string<br>    disabled                = bool<br>    priority                = number<br>    source_service_accounts = set(string)<br>    source_tags             = set(string)<br>    target_service_accounts = set(string)<br>    target_tags             = set(string)<br>    log_config = set(object({<br>      metadata = string<br>    }))<br>  }))</pre> | `{}` | no |

## Outputs

No outputs.

[^]: (autogen_docs_end)
