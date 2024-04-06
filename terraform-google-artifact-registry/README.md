# Artifact Registry
This module creates Google Artifact Registry 

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
| [google-beta_google_artifact_registry_repository.this](https://registry.terraform.io/providers/hashicorp/google-beta/latest/docs/resources/google_artifact_registry_repository) | resource |
| [google-beta_google_artifact_registry_repository_iam_member.cloudrun_read](https://registry.terraform.io/providers/hashicorp/google-beta/latest/docs/resources/google_artifact_registry_repository_iam_member) | resource |
| [google-beta_google_artifact_registry_repository_iam_member.readonly](https://registry.terraform.io/providers/hashicorp/google-beta/latest/docs/resources/google_artifact_registry_repository_iam_member) | resource |
| [google-beta_google_artifact_registry_repository_iam_member.readwrite](https://registry.terraform.io/providers/hashicorp/google-beta/latest/docs/resources/google_artifact_registry_repository_iam_member) | resource |
| [google-beta_google_project_service_identity.cloudrun](https://registry.terraform.io/providers/hashicorp/google-beta/latest/docs/resources/google_project_service_identity) | resource |
| [google_project_service.containerscanning](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_service) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_enable_scanning"></a> [enable\_scanning](#input\_enable\_scanning) | Enable Container Vulnerability scanning | `bool` | `true` | no |
| <a name="input_kms_key_name"></a> [kms\_key\_name](#input\_kms\_key\_name) | The Cloud KMS resource name of the customer managed encryption key | `string` | `""` | no |
| <a name="input_labels"></a> [labels](#input\_labels) | Labels with user-defined metadata | `map(any)` | `{}` | no |
| <a name="input_permission_readonly"></a> [permission\_readonly](#input\_permission\_readonly) | List of IAM Members to attach Read Only Permission | `set(string)` | `[]` | no |
| <a name="input_permission_readwrite"></a> [permission\_readwrite](#input\_permission\_readwrite) | List of IAM Members to attach Read/Write permission | `set(string)` | `[]` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | Project ID where to create Artifact Registry | `string` | n/a | yes |
| <a name="input_projects_cloudrun_agent_read_access"></a> [projects\_cloudrun\_agent\_read\_access](#input\_projects\_cloudrun\_agent\_read\_access) | List of Project IDs to allow Read access for Google Cloud Run Service Agent | `set(string)` | `[]` | no |
| <a name="input_region"></a> [region](#input\_region) | Region where to create Artifact Registry | `string` | n/a | yes |
| <a name="input_repository_description"></a> [repository\_description](#input\_repository\_description) | Description of Artifact Registry | `string` | `"Artifact Registry"` | no |
| <a name="input_repository_format"></a> [repository\_format](#input\_repository\_format) | The format of packages: DOCKER, MAVEN, NPM, PYTHON, APT, YUM | `string` | `"DOCKER"` | no |
| <a name="input_repository_id"></a> [repository\_id](#input\_repository\_id) | The last part of the repository name | `string` | `"docker_repository"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | n/a |
| <a name="output_name"></a> [name](#output\_name) | n/a |

[^]: (autogen_docs_end)

# Example terragrunt.hcl usage
```hcl
terraform {
  source = "git@github.com:meorg/gcp-terraform-module.git//terraform-google-artifact-registry"
}

locals {
  common_vars    = yamldecode(file(find_in_parent_folders("vars.yaml")))
  environment    = basename(dirname(dirname(get_terragrunt_dir()))) 
  resource_group = basename(dirname(get_terragrunt_dir()))          
  resource       = basename(get_terragrunt_dir())                   
  resource_vars  = local.common_vars["Environments"][local.environment]["Resources"][local.resource_group][local.resource]
}

inputs = merge(local.resource_vars["inputs"], {
  project_id = dependency.project.outputs.projects["service"].project_id
  region     = local.common_vars["Environments"][local.environment]["Region"]
  labels     = local.common_vars["common"]["labels"]
  # permission_readwrite = ["user:denis@opsguru.io", "user:danny@opsguru.io"]
  # permission_readonly  = ["user:paul@opsguru.io"]
  projects_cloudrun_agent_read_access = [
    "gcp-clp-eu-dev",
    "gcp-clp-eu-prd",
    "gcp-clp-us-dev",
    "gcp-clp-us-stg",
    "gcp-clp-us-prd",
    "gcp-clp-ap-dev",
    "gcp-clp-ap-prd",
    "gcp-clp-sandbox"
  ]
})

include {
  path = find_in_parent_folders()
}

dependencies { paths = [
  "../project", // path to project module
  "../../clp-base" // path to base module
] }

dependency "project" {
  config_path = "../project"
}

dependency "clp-base" {
  config_path = "../../clp-base"
}

```
