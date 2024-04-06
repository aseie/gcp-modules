# firewall
This module creates organization firewall policy rules.

# Example terragrunt.hcl usage
```hcl
inputs = {
  org_policy = true
  org_policy = {
    parent      = "organizations/${local.common_vars.common.org_id}" # Can be folder/folder_id
    description = "Allow rules that are applied globally"
    rules = {
      ssh = {
        rule_description   = "Allow SSH"
        action             = "allow"
        direction          = "INGRESS"
        enable_logging     = false
        match = [
          {
            description = "SSH Rule"
            config = [
              {
                src_ip_ranges  = ["35.235.240.0/20"] # 35.235.240.0/20 GCP IAP IP for cloudshell
                dest_ip_ranges = null
                layer4_config = [
                  {
                    ip_protocol = "tcp"
                    ports       = ["22"]
                  },
                ]
              },
            ]
          },
        ]
        priority                = 1000
        preview                 = false
        target_resources        = []
        target_service_accounts = []
      },
      ping = {
        rule_description   = "Allow ping policy"
        action             = "allow"
        direction          = "INGRESS"
        enable_logging     = false
        match = [
          {
            description = "ICMP Rule"
            config = [
              {
                src_ip_ranges  = ["10.0.0.0/8"]
                dest_ip_ranges = null
                layer4_config = [
                  {
                    ip_protocol = "icmp"
                    ports       = null
                  },
                ]
              },
            ]
          },
        ]
        priority                = 1001
        preview                 = false
        target_resources        = []
        target_service_accounts = []
      },
      healthchecks = {
        rule_description   = "Allow CIDR ranges for LB healthchecks"
        action             = "allow"
        direction          = "INGRESS"
        enable_logging     = false
        match = [
          {
            description = "Allow CIDR ranges for LB healthchecks"
            config = [
              {
                src_ip_ranges  = ["35.191.0.0/16", "130.211.0.0/22", "209.85.152.0/22", "209.85.204.0/22"]
                dest_ip_ranges = null
                layer4_config = [
                  {
                    ip_protocol = "all"
                    ports       = null
                  },
                ]
              },
            ]
          },
        ]
        priority                = 1008
        preview                 = false
        target_resources        = []
        target_service_accounts = []
      },
    }
  }
  
  firewall_policies = {
    dummy-policy = {
      parent = dependency.admin.outputs.folders["Dev"].name
      description = "Dev policy"
    }
  }

  firewall_rules = {
    dummy-policy = [
      {
        name               = "allow-ping"
        description        = "Allow ping policy"
        action             = "allow"
        direction          = "INGRESS"
        enable_logging     = false
        disabled           = false
        match = [
          {
            layer4_config = [
              {
                ip_protocol = "icmp"
                ports       = null
              }
            ]
            src_ip_ranges  = ["10.0.0.0/8"]
            dest_ip_ranges = null
          }
        ]
        priority                = 1000
        preview                 = false
        target_resources        = []
        target_service_accounts = []
      }
    }
  ]
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
| <a name="provider_google-beta"></a> [google-beta](#provider\_google-beta) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google-beta_google_compute_firewall_policy_association.policy](https://registry.terraform.io/providers/hashicorp/google-beta/latest/docs/resources/google_compute_firewall_policy_association) | resource |
| [google-beta_google_compute_organization_security_policy.global](https://registry.terraform.io/providers/hashicorp/google-beta/latest/docs/resources/google_compute_organization_security_policy) | resource |
| [google-beta_google_compute_organization_security_policy_association.global](https://registry.terraform.io/providers/hashicorp/google-beta/latest/docs/resources/google_compute_organization_security_policy_association) | resource |
| [google-beta_google_compute_organization_security_policy_rule.rule](https://registry.terraform.io/providers/hashicorp/google-beta/latest/docs/resources/google_compute_organization_security_policy_rule) | resource |
| [google_compute_firewall_policy.policy](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_firewall_policy) | resource |
| [google_compute_firewall_policy_rule.rule](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_firewall_policy_rule) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_firewall_policies"></a> [firewall\_policies](#input\_firewall\_policies) | Firewall policies config. Key = policy short name, Value = parent(If not specified org\_parent will be used), attachment\_target & description(optional) | `map(any)` | <pre>{<br>  "infra": {<br>    "attachment_target": "folders/infra_id",<br>    "description": "Infra example policy",<br>    "parent": "organizations/org_id"<br>  }<br>}</pre> | no |
| <a name="input_firewall_rules"></a> [firewall\_rules](#input\_firewall\_rules) | Firewall policies rules. Key = policy short name, Value = rules config | <pre>map(list(object({<br>    name            = string<br>    priority        = number<br>    action          = string<br>    direction       = string<br>    enable_logging  = bool<br>    disabled        = any<br>    description     = string<br>    match = list(object({<br>      src_ip_ranges  = list(string)<br>      dest_ip_ranges = list(string)<br>      layer4_config  = list(object({<br>        ip_protocol  = string<br>        ports        = list(string)<br>      }))<br>    }))<br>  })))</pre> | n/a | yes |
| <a name="input_org_firewall"></a> [org\_firewall](#input\_org\_firewall) | Organization firewall policy config | <pre>object({<br>    parent      = string<br>    description = string<br>    rules = map(object({<br>      rule_description = string<br>      action           = string<br>      direction        = string<br>      enable_logging   = bool<br>      match = list(object({<br>        description = string<br>        config = list(object({<br>          src_ip_ranges  = list(string)<br>          dest_ip_ranges = list(string)<br>          layer4_config = list(object({<br>            ip_protocol = string<br>            ports       = list(string)<br>          }))<br>        }))<br>      }))<br>      priority                = number<br>      preview                 = bool<br>      target_resources        = list(string)<br>      target_service_accounts = list(string)<br>    }))<br>  })</pre> | n/a | yes |
| <a name="input_org_policy"></a> [org\_policy](#input\_org\_policy) | Set to true if you're creating org\_policies, false for project lvl | `bool` | `true` | no |

## Outputs

No outputs.

[^]: (autogen_docs_end)
