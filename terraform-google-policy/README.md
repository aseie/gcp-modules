# DNS Ops Guru
This is the Ops Guru opinionated dns root module intended to be used in different architecture profiles.

# Example terragrunt.hcl usage
```hcl
terraform {
  source = "https://gitlab.com/MyRepo/applications/devops/tf-modules.git//terraform-google-policy"
}

include {
  path = find_in_parent_folders()
}
   
dependency "net-vpc" {
  config_path = "../net-vpc"
}

inputs = {
  org_policies = {
      "constraints/compute.trustedImageProjects" = {
      allow             = [],
      allow_list_length = 0,
      deny              = [],
      deny_list_length  = 0,
      policy_type       = "list",
      policy_for        = "folder"
      organization_id   = null,
      folder_id         = local.common_vars.common.root_folder,
      project_id        = null,
      enforce           = false,
      exclude_folders   = [],
      exclude_projects  = []
    },
  }
}

locals {
  common_vars   = yamldecode(file(find_in_parent_folders("vars.yaml")))
  environment   = basename(dirname(get_terragrunt_dir()))
  resource      = basename(get_terragrunt_dir())
  resource_vars = local.common_vars["Environments"]["${local.environment}"]["Resources"]["${local.resource}"]
}

dependencies { paths = [
  "../admin"
] }

dependency "admin" {
  config_path = "../admin"
}
```

[^]: (autogen_docs_start)
## Requirements

No requirements.

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_policy"></a> [policy](#module\_policy) | terraform-google-modules/org-policy/google | 5.0 |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_org_policies"></a> [org\_policies](#input\_org\_policies) | n/a | <pre>map(<br>    object({<br>      allow             = list(string),<br>      deny              = list(string),<br>      policy_type       = string,<br>      policy_for        = string,<br>      organization_id   = string,<br>      folder_id         = string,<br>      project_id        = string,<br>      enforce           = bool,<br>      exclude_folders   = set(string),<br>      exclude_projects  = set(string)<br>    })<br>  )</pre> | `{}` | no |

## Outputs

No outputs.

[^]: (autogen_docs_end)
