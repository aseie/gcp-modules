module "policy" {
  for_each = var.org_policies
  source   = "terraform-google-modules/org-policy/google"
  version  = "~> 5.2"

  constraint        = each.key
  allow             = each.value.allow
  allow_list_length = length(var.org_policies[each.key].allow)
  deny              = var.org_policies[each.key].deny
  deny_list_length  = length(var.org_policies[each.key].deny)
  policy_type       = var.org_policies[each.key].policy_type
  policy_for        = var.org_policies[each.key].policy_for
  organization_id   = var.org_policies[each.key].organization_id
  folder_id         = var.org_policies[each.key].folder_id
  project_id        = var.org_policies[each.key].project_id
  enforce           = var.org_policies[each.key].enforce
  exclude_folders   = var.org_policies[each.key].exclude_folders
  exclude_projects  = var.org_policies[each.key].exclude_projects
}
