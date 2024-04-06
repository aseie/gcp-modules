variable "org_policy" {
  description = "Set to true if you're creating org_policies, false for project lvl"
  type        = bool
  default     = true
}
variable "org_firewall" {
  description = "Organization firewall policy config"
  type = object({
    name        = string
    parent      = string
    description = string
    rules = map(object({
      rule_description = string
      action           = string
      direction        = string
      enable_logging   = bool
      match = list(object({
        description = string
        config = list(object({
          src_ip_ranges  = list(string)
          dest_ip_ranges = list(string)
          layer4_config = list(object({
            ip_protocol = string
            ports       = list(string)
          }))
        }))
      }))
      priority                = number
      preview                 = bool
      target_resources        = list(string)
      target_service_accounts = list(string)
    }))
  })
}

variable "firewall_policies" {
  description = "Firewall policies config. Key = policy short name, Value = parent(If not specified org_parent will be used), attachment_target & description(optional)"
  type = map(any)
  default = {
    "infra" = {
      attachment_target = "folders/infra_id"
      description = "Infra example policy"
      parent = "organizations/org_id"
    }
  }
}

variable "firewall_rules" {
  description = "Firewall policies rules. Key = policy short name, Value = rules config"
  type = map(list(object({
    name            = string
    priority        = number
    action          = string
    direction       = string
    enable_logging  = bool
    disabled        = any
    description     = string
    match = list(object({
      src_ip_ranges  = list(string)
      dest_ip_ranges = list(string)
      layer4_config  = list(object({
        ip_protocol  = string
        ports        = list(string)
      }))
    }))
  })))
}
