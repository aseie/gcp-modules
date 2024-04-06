variable "org_policies" {
  type = map(
    object({
      allow             = list(string),
      deny              = list(string),
      policy_type       = string,
      policy_for        = string,
      organization_id   = string,
      folder_id         = string,
      project_id        = string,
      enforce           = bool,
      exclude_folders   = set(string),
      exclude_projects  = set(string)
    })
  )
  default = {}
}
