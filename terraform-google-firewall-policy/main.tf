resource "google_compute_organization_security_policy" "global" {
  count        = var.org_policy ? 1 : 0

  provider     = google-beta
  display_name = var.org_firewall.name
  parent       = var.org_firewall.parent
  description  = var.org_firewall.description
  type         = "FIREWALL"
}

resource "google_compute_organization_security_policy_rule" "rule" {
  for_each       = var.org_firewall.rules
  
  provider       = google-beta
  description    = each.value.rule_description
  policy_id      = var.org_policy ? google_compute_organization_security_policy.global.0.id : ""
  action         = each.value.action
  direction      = each.value.direction
  enable_logging = each.value.enable_logging

  dynamic "match" {
    for_each = each.value.match
    content {
      description    = match.value.description
      versioned_expr = "FIREWALL"

      dynamic "config" {
        for_each = match.value.config
        content {
          src_ip_ranges  = config.value.src_ip_ranges
          dest_ip_ranges = config.value.dest_ip_ranges

          dynamic "layer4_config" {
            for_each = config.value.layer4_config
            content {
              ip_protocol = layer4_config.value.ip_protocol
              ports       = layer4_config.value.ports
            }
          }
        }
      }
    }
  }
  priority                = each.value.priority
  preview                 = each.value.preview
  target_resources        = each.value.target_resources
  target_service_accounts = each.value.target_service_accounts
}

resource "google_compute_organization_security_policy_association" "global" {
  count         = var.org_policy ? 1 : 0

  provider      = google-beta
  name          = "global"
  attachment_id = var.org_policy ? google_compute_organization_security_policy.global.0.parent : ""
  policy_id     = var.org_policy ? google_compute_organization_security_policy.global.0.id : ""
}

resource "google_compute_firewall_policy" "policy" {
  for_each    = local.firewall_policies

  parent      = each.value.parent
  short_name  = each.key
  description = lookup(each.value, "description", null)
}

locals {
  firewall_policies = { for policy, config in var.firewall_policies : policy =>
    merge(config, { "parent" = lookup(config, "parent", var.org_firewall.parent) })
  }

  firewall_rules = { 
    for policy, config in var.firewall_rules : policy => [
      for rule in config :
        merge(rule, { "firewall_policy" = google_compute_firewall_policy.policy[policy].id })
    ]
  }

  rules_list = flatten([
    for policy, rules in local.firewall_rules : rules
  ])
}

resource "google_compute_firewall_policy_rule" "rule" {
  for_each        = { for i, rule in local.rules_list : "${i+1}-${rule.name}" => rule }
  firewall_policy = lookup(each.value, "firewall_policy", null)
  description     = lookup(each.value, "description", null)
  priority        = lookup(each.value, "priority", null)
  enable_logging  = lookup(each.value, "enable_logging", true)
  action          = lookup(each.value, "action", null)
  direction       = lookup(each.value, "direction", null)
  disabled        = lookup(each.value, "disabled", false)

  dynamic "match" {
    for_each = each.value.match
    content {
      src_ip_ranges  = lookup(match.value, "src_ip_ranges", null)
      dest_ip_ranges = lookup(match.value, "dest_ip_ranges", null)
      dynamic "layer4_configs" {
        for_each = lookup(match.value, "layer4_config", {})
        content {
          ip_protocol  = lookup(layer4_configs.value, "ip_protocol", null)
          ports        = lookup(layer4_configs.value, "ports", [])
        }
      }
    }
  }
}

resource "google_compute_firewall_policy_association" "policy" {
  for_each          = var.firewall_policies

  provider          = google-beta
  name              = each.key
  attachment_target = each.value.attachment_target
  firewall_policy   = google_compute_firewall_policy.policy[each.key].id
}
