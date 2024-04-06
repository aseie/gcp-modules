# Projects
This module is in charge of creating projects that can become service projects with proper usage of
[iam-permissions](../iam-permissions) module. With this module you can create any number of projects with VPCs
(non shared) and service accounts.

# Usage within terragrunt.hcl
```hcl
inputs = {
  service_projects = {
    big-gke-project = {
      folder_id                   = local.admin_dep.dependency.admin.outputs.folders["clusters/dev"].name
      lien                        = false
      skip_gcloud_download        = true
      service_accounts            = [
        "big-gke-sa",
        "sample-automation"
      ]
      active_apis                 = [
        "container.googleapis.com",
        "compute.googleapis.com",
      ]
      activate_api_identities     = []
      shared_vpc                  = ""
      random_project_id           = true
      disable_dependent_services  = true
      disable_services_on_destroy = true
      shared_vpc_subnets          = []
      project_quotas: # Project quotas can be defined in this block 
        service: # must match service project key name
          service: "compute.googleapis.com" # type of service for the quota
          metric: "global_internal_addresses" # metric for the quota
          limit: "%2Fproject" # kind of limit applied
          override_value: "64" # value
        big-gke-project:
          service: "compute.googleapis.com"
          metric: "global_internal_addresses"
          limit: "%2Fproject"
          override_value: "64"
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
| <a name="provider_google-beta"></a> [google-beta](#provider\_google-beta) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_active_apis"></a> [active\_apis](#module\_active\_apis) | terraform-google-modules/project-factory/google//modules/project_services | ~> 13.0 |
| <a name="module_kms_rings"></a> [kms\_rings](#module\_kms\_rings) | terraform-google-modules/kms/google | ~> 2.1 |
| <a name="module_project_iam"></a> [project\_iam](#module\_project\_iam) | terraform-google-modules/iam/google//modules/projects_iam | ~> 7.4 |
| <a name="module_service_project"></a> [service\_project](#module\_service\_project) | terraform-google-modules/project-factory/google | ~> 13.0 |
| <a name="module_vpc"></a> [vpc](#module\_vpc) | terraform-google-modules/network/google | ~> 5.1 |

## Resources

| Name | Type |
|------|------|
| [google-beta_google_compute_global_address.private](https://registry.terraform.io/providers/hashicorp/google-beta/latest/docs/resources/google_compute_global_address) | resource |
| [google-beta_google_service_networking_connection.private_vpc_connection](https://registry.terraform.io/providers/hashicorp/google-beta/latest/docs/resources/google_service_networking_connection) | resource |
| [google-beta_google_service_usage_consumer_quota_override.quota](https://registry.terraform.io/providers/hashicorp/google-beta/latest/docs/resources/google_service_usage_consumer_quota_override) | resource |
| [google_service_account.service_accounts](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account) | resource |
| [google_organization.org](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/organization) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_billing_account"></a> [billing\_account](#input\_billing\_account) | Billing Account | `string` | n/a | yes |
| <a name="input_domain"></a> [domain](#input\_domain) | Organization domain | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment | `string` | n/a | yes |
| <a name="input_gke_iam"></a> [gke\_iam](#input\_gke\_iam) | List of projects for which you want to create GKE IAM binding | `list(any)` | `[]` | no |
| <a name="input_gke_iam_projects"></a> [gke\_iam\_projects](#input\_gke\_iam\_projects) | List of project ids for GKE IAM binding | `list` | `[]` | no |
| <a name="input_kms_rings"></a> [kms\_rings](#input\_kms\_rings) | Map of KMS keyrings with keys and owners | <pre>map(object({<br>    keyring        = string<br>    location       = string<br>    keys           = list(string)<br>    set_owners_for = list(string)<br>    owners         = list(string)<br>  }))</pre> | `{}` | no |
| <a name="input_project_quotas"></a> [project\_quotas](#input\_project\_quotas) | Map of Project quotas to override | <pre>map(object({<br>    service        = string<br>    metric         = string<br>    limit          = string<br>    override_value = string<br>  }))</pre> | n/a | yes |
| <a name="input_service_projects"></a> [service\_projects](#input\_service\_projects) | Map of service projects and their configs. Key = project\_name Value = Project Factory Config. More info: https://github.com/terraform-google-modules/terraform-google-project-factory/tree/v9.0.0 | <pre>map(object({<br>    project_name                = string<br>    folder_id                   = string<br>    lien                        = bool<br>    service_accounts            = list(string)<br>    active_apis                 = list(string)<br>    activate_api_identities     = list(object({ api = string, roles = list(string) }))<br>    random_project_id           = bool<br>    disable_dependent_services  = bool<br>    disable_services_on_destroy = bool<br>    shared_vpc_host_name        = string<br>    shared_vpc_subnets          = list(string)<br>    credentials_path            = string<br>    default_service_account     = string<br>  }))</pre> | `{}` | no |
| <a name="input_vpcs"></a> [vpcs](#input\_vpcs) | This option allows creation of VPCs in the service project if shared VPC is not enough. Key = Project Name, Value = Network Config. More info: https://github.com/terraform-google-modules/terraform-google-network/tree/v2.5.0 | <pre>map(object({<br>    network_name     = string<br>    subnets          = list(map(string))<br>    secondary_ranges = map(list(object({ range_name = string, ip_cidr_range = string })))<br>  }))</pre> | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_active_apis"></a> [active\_apis](#output\_active\_apis) | Map of projects and their active apis |
| <a name="output_kms_rings"></a> [kms\_rings](#output\_kms\_rings) | Map of projects and kms rings |
| <a name="output_projects"></a> [projects](#output\_projects) | Map of projects and their outputs from the project factory |
| <a name="output_service_accounts"></a> [service\_accounts](#output\_service\_accounts) | Map of projects and their service\_accounts |
| <a name="output_vpcs"></a> [vpcs](#output\_vpcs) | Map of projects and their outputs from the network factory |

[^]: (autogen_docs_end)
