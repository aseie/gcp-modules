# shared-vpc
This module will setup a host project with shared vpc. The module will:
* Create a host project
* Create a VPC
* Create subnetworks with specified secondary ranges
* Creeate routes if specified
* Create specified service accounts
* Create Cloud NATs per region

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
| <a name="module_cloud-nat"></a> [cloud-nat](#module\_cloud-nat) | terraform-google-modules/cloud-nat/google | 1.4 |
| <a name="module_host_project"></a> [host\_project](#module\_host\_project) | terraform-google-modules/project-factory/google | 10.2.1 |
| <a name="module_subnets_beta"></a> [subnets\_beta](#module\_subnets\_beta) | terraform-google-modules/network/google//modules/subnets-beta | 3.1.2 |
| <a name="module_vpc"></a> [vpc](#module\_vpc) | terraform-google-modules/network/google | 3.1.2 |

## Resources

| Name | Type |
|------|------|
| [google-beta_google_compute_global_address.private_ip_address](https://registry.terraform.io/providers/hashicorp/google-beta/latest/docs/resources/google_compute_global_address) | resource |
| [google-beta_google_service_networking_connection.private_vpc_connection](https://registry.terraform.io/providers/hashicorp/google-beta/latest/docs/resources/google_service_networking_connection) | resource |
| [google_service_account.service_accounts](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account) | resource |
| [google_organization.org](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/organization) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_active_apis"></a> [active\_apis](#input\_active\_apis) | List of API to activate on the host project | `list(string)` | <pre>[<br>  "compute.googleapis.com",<br>  "logging.googleapis.com"<br>]</pre> | no |
| <a name="input_billing_account"></a> [billing\_account](#input\_billing\_account) | Billing Account | `string` | n/a | yes |
| <a name="input_cloud_nats"></a> [cloud\_nats](#input\_cloud\_nats) | Cloud Nat Setup | <pre>map(object({<br>    router_name                        = string<br>    router_asn                         = string<br>    source_subnetwork_ip_ranges_to_nat = string<br>    log_config_enable                  = bool<br>    log_config_filter                  = string<br>    subnetworks = list(object({<br>      name                     = string,<br>      source_ip_ranges_to_nat  = list(string)<br>      secondary_ip_range_names = list(string)<br>    }))<br>  }))</pre> | `{}` | no |
| <a name="input_create_private_connaction"></a> [create\_private\_connaction](#input\_create\_private\_connaction) | create private network connacation for CloudSQL or not | `bool` | `false` | no |
| <a name="input_credentials_path"></a> [credentials\_path](#input\_credentials\_path) | Path to a service account credentials file with rights to run the Project Factory. If this file is absent Terraform will fall back to Application Default Credentials. | `string` | `""` | no |
| <a name="input_default_service_account"></a> [default\_service\_account](#input\_default\_service\_account) | Project default service account setting: can be one of `delete`, `deprivilege`, `disable`, or `keep`. | `string` | `"deprivilege"` | no |
| <a name="input_domain"></a> [domain](#input\_domain) | Organization domain | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment | `string` | n/a | yes |
| <a name="input_folder_id"></a> [folder\_id](#input\_folder\_id) | If specified, the host project will be created under this folder | `string` | `null` | no |
| <a name="input_host_project_name"></a> [host\_project\_name](#input\_host\_project\_name) | Host Project Name suffix. Project ID will be {var.host\_project\_name}-{var.geo}-{var.environment} | `string` | n/a | yes |
| <a name="input_lien"></a> [lien](#input\_lien) | If set to false the lien is disabled | `bool` | `false` | no |
| <a name="input_network_name"></a> [network\_name](#input\_network\_name) | The name of the network being created | `string` | n/a | yes |
| <a name="input_private_service_connaction_address"></a> [private\_service\_connaction\_address](#input\_private\_service\_connaction\_address) | private network connacation for CloudSQL | `string` | `""` | no |
| <a name="input_routes"></a> [routes](#input\_routes) | List of routes being created in this VPC | `list(map(string))` | `[]` | no |
| <a name="input_secondary_ranges"></a> [secondary\_ranges](#input\_secondary\_ranges) | Secondary ranges that will be used in some of the subnets | `map(list(object({ range_name = string, ip_cidr_range = string })))` | `{}` | no |
| <a name="input_service_accounts"></a> [service\_accounts](#input\_service\_accounts) | List of service accounts to be created in the host project | `list(string)` | `[]` | no |
| <a name="input_subnets"></a> [subnets](#input\_subnets) | The list of subnets being created | `list(map(string))` | `[]` | no |
| <a name="input_subnets_beta"></a> [subnets\_beta](#input\_subnets\_beta) | The list of subnets being created. For beta features | `list(map(string))` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_budget_name"></a> [budget\_name](#output\_budget\_name) | The name of the budget if created |
| <a name="output_domain"></a> [domain](#output\_domain) | The organization's domain |
| <a name="output_group_email"></a> [group\_email](#output\_group\_email) | The email of the G Suite group with group\_name |
| <a name="output_network"></a> [network](#output\_network) | The created network |
| <a name="output_network_name"></a> [network\_name](#output\_network\_name) | The name of the VPC being created |
| <a name="output_network_self_link"></a> [network\_self\_link](#output\_network\_self\_link) | The URI of the VPC being created |
| <a name="output_project_bucket_self_link"></a> [project\_bucket\_self\_link](#output\_project\_bucket\_self\_link) | Project's bucket selfLink |
| <a name="output_project_bucket_url"></a> [project\_bucket\_url](#output\_project\_bucket\_url) | Project's bucket url |
| <a name="output_project_id"></a> [project\_id](#output\_project\_id) | VPC project id |
| <a name="output_project_name"></a> [project\_name](#output\_project\_name) | Project factory outputs |
| <a name="output_project_number"></a> [project\_number](#output\_project\_number) | n/a |
| <a name="output_proxy_subnets"></a> [proxy\_subnets](#output\_proxy\_subnets) | A map with keys of form subnet\_region/subnet\_name and values being the outputs of the google\_compute\_subnetwork resources used to create corresponding proxy subnets. |
| <a name="output_route_names"></a> [route\_names](#output\_route\_names) | The route names associated with this VPC |
| <a name="output_service_account_display_name"></a> [service\_account\_display\_name](#output\_service\_account\_display\_name) | The display name of the default service account |
| <a name="output_service_account_email"></a> [service\_account\_email](#output\_service\_account\_email) | The email of the default service account |
| <a name="output_service_account_id"></a> [service\_account\_id](#output\_service\_account\_id) | The id of the default service account |
| <a name="output_service_account_name"></a> [service\_account\_name](#output\_service\_account\_name) | The fully-qualified name of the default service account |
| <a name="output_service_account_unique_id"></a> [service\_account\_unique\_id](#output\_service\_account\_unique\_id) | The unique id of the default service account |
| <a name="output_subnets"></a> [subnets](#output\_subnets) | A map with keys of form subnet\_region/subnet\_name and values being the outputs of the google\_compute\_subnetwork resources used to create corresponding subnets. |
| <a name="output_subnets_flow_logs"></a> [subnets\_flow\_logs](#output\_subnets\_flow\_logs) | Whether the subnets will have VPC flow logs enabled |
| <a name="output_subnets_ips"></a> [subnets\_ips](#output\_subnets\_ips) | The IPs and CIDRs of the subnets being created |
| <a name="output_subnets_names"></a> [subnets\_names](#output\_subnets\_names) | The names of the subnets being created |
| <a name="output_subnets_private_access"></a> [subnets\_private\_access](#output\_subnets\_private\_access) | Whether the subnets will have access to Google API's without a public IP |
| <a name="output_subnets_regions"></a> [subnets\_regions](#output\_subnets\_regions) | The region where the subnets will be created |
| <a name="output_subnets_secondary_ranges"></a> [subnets\_secondary\_ranges](#output\_subnets\_secondary\_ranges) | The secondary ranges associated with these subnets |
| <a name="output_subnets_self_links"></a> [subnets\_self\_links](#output\_subnets\_self\_links) | The self-links of subnets being created |

[^]: (autogen_docs_end)

# Example terragrunt.hcl usage
```hcl
inputs = {
  environment = "dev"
  billing_account = "11112222333"
  folder_id = "folders/445566"
  domain = "opsguru.io"
  host_project_name = "host-project"
  network_name = "shared-vpc"
  // Specify subnet ranges
  subnets = [
    {
      subnet_name           = "general"
      subnet_ip             = "10.0.0.0/24"
      subnet_region         = "us-east1"
      subnet_private_access = true
      subnet_flow_logs      = true
    },
    {
      subnet_name           = "gke"
      subnet_ip             = "10.0.1.0/24"
      subnet_region         = "us-west1"
      subnet_private_access = true
      subnet_flow_logs      = true
    },
  ]
  // Specify secondary range for each subnet
  secondary_ranges = {
    gke = [
      {
        range_name    = "pods"
        ip_cidr_range = "10.1.0.0/16"
      },
      {
        range_name    = "services"
        ip_cidr_range = "10.2.0.0/22"
      },
    ]
    general = []
  }
  // Optional routes
  routes = [
    {
      name                   = "egress-internet"
      description            = "route through IGW to access internet"
      destination_range      = "0.0.0.0/0"
      tags                   = "egress-inet"
      next_hop_internet      = "true"
    },
  ]
  // Specify a cloud_nat per region
  cloud_nats = {
    us-west1 = {
      router_name                        = "router-us-west1"
      router_asn                         = "64514"
      source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
      log_config_enable                  = true
      log_config_filter                  = "ERRORS_ONLY"
      subnetworks = []
    }
  }
  // Add service accounts per your use case.
  service_accounts = [
    "sa-1",
    "sa-2"
  ]
}
```
