# Administration
This module creates an administration project, a GCS bucket for this module's state, and GCS buckets for the environment
state files. Use this module as a bootstrap for the new environments.

## Prerequisite
Give your account the following permissions at the org level:
* roles/resourcemanager.folderAdmin
* roles/resourcemanager.organizationViewer
* roles/resourcemanager.projectCreator
* roles/billing.user
* roles/storage.admin

## How to run this module
1. Run `gcloud auth login` and login with your account.
1. Create a `terragrunt.hcl` file like this:
```hcl
terraform {
  source = "git@github.com:yourRepo/terraform-google-administration.git"
}

inputs = {
  billing_account    = "015359-0959E6-5F2575" //change to fit your user cast
  admin_project_name = "super-awesome-admin" //change to fit your user cast
  admin_state_bucket = "super-awesome-admin-tf-state" //change to fit your user cast
  domain             = "opsguru.io" //change to fit your user cast
}
```
1. Run `terragrunt init`
1. Run `terragrunt apply`
1. Add the following sections to your terragrunt.hcl
```hcl
remote_state {
  backend = "gcs"
  config = {
    bucket = "super-awesome-admin-tf-state" // Must be the same as admin_state_bucket variable
    prefix = "administration"
  }
  generate = {
    path = "backend.tf"
    if_exists = "overwrite"
  }
}
```
1. Run `terragrunt init`
1. When asked `"Do you want to copy existing state to the new backend?"` type `yes`

### Changed
- Bumped terraform-google-project-factory version to 10.1.1
- Enforce uniform\_bucket\_level\_access on storage buckets
- Removed deprecated module argument skip_gcloud_download
- Bumped google and google-beta providers version to 3.50

### Added
- Abiliity to create folder structure under an organization folder
- Added terraform 0.14 support


[^]: (autogen_docs_start)
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_admin_project"></a> [admin\_project](#module\_admin\_project) | terraform-google-modules/project-factory/google | 10.2.1 |

## Resources

| Name | Type |
|------|------|
| [google_folder.admin_folder](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/folder) | resource |
| [google_folder.level_1](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/folder) | resource |
| [google_folder.level_2](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/folder) | resource |
| [google_folder.level_3](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/folder) | resource |
| [google_folder.level_4](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/folder) | resource |
| [google_folder.level_5](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/folder) | resource |
| [google_service_account.terraform_sa_accounts](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account) | resource |
| [google_storage_bucket.terraform_state_buckets](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket) | resource |
| [google_storage_bucket.this_admin_state_file](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket) | resource |
| [google_folder.org_parent_folder](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/folder) | data source |
| [google_organization.org](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/organization) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_active_apis"></a> [active\_apis](#input\_active\_apis) | List of API to activate on the project | `list(string)` | <pre>[<br>  "logging.googleapis.com",<br>  "compute.googleapis.com",<br>  "serviceusage.googleapis.com",<br>  "iam.googleapis.com",<br>  "cloudbilling.googleapis.com"<br>]</pre> | no |
| <a name="input_admin_folder"></a> [admin\_folder](#input\_admin\_folder) | Wheater to create admin folder or not | `bool` | `true` | no |
| <a name="input_admin_folder_name"></a> [admin\_folder\_name](#input\_admin\_folder\_name) | Name of the folder that will be created if admin\_folder = true | `string` | `"admin"` | no |
| <a name="input_admin_project_id"></a> [admin\_project\_id](#input\_admin\_project\_id) | The ID to give the project. If not provided, the `name` will be used. | `string` | `""` | no |
| <a name="input_admin_project_name"></a> [admin\_project\_name](#input\_admin\_project\_name) | Admin Project Name | `string` | `"administration"` | no |
| <a name="input_admin_random_project_id"></a> [admin\_random\_project\_id](#input\_admin\_random\_project\_id) | Flag to enable random suffix generation | `bool` | `true` | no |
| <a name="input_admin_state_bucket"></a> [admin\_state\_bucket](#input\_admin\_state\_bucket) | Admin GCS bucket name for this module state file | `string` | n/a | yes |
| <a name="input_admin_state_bucket_location"></a> [admin\_state\_bucket\_location](#input\_admin\_state\_bucket\_location) | Location of the admin\_state\_bucket | `string` | `"US"` | no |
| <a name="input_billing_account"></a> [billing\_account](#input\_billing\_account) | Billing Account | `string` | n/a | yes |
| <a name="input_create_admin_bukets"></a> [create\_admin\_bukets](#input\_create\_admin\_bukets) | Wheater to create admin\_state\_bucket. Turn this off when using with Terraform Cloud. | `bool` | `true` | no |
| <a name="input_domain"></a> [domain](#input\_domain) | Organization domain | `string` | n/a | yes |
| <a name="input_environment_state_buckets"></a> [environment\_state\_buckets](#input\_environment\_state\_buckets) | Mapping of the state bucket suffix and location. The GCS bucket name will be in the form <ADMIN-PROJECT-ID>-<SUFFIX>. | `map(string)` | <pre>{<br>  "eu-dev": "eu",<br>  "eu-prd": "eu",<br>  "eu-stg": "eu",<br>  "us-dev": "us",<br>  "us-prd": "us",<br>  "us-stg": "us"<br>}</pre> | no |
| <a name="input_folders"></a> [folders](#input\_folders) | Define a folder structure for your organization. You can define the struture up to 5 levels deep. Levels 2-5 map a child folder to a parent folder. Example {level1=[us, eu], level2 = [{name = tenant, parent = us}], level3 = [{name = dev, parent = us/tenant}] | <pre>object({<br>    level1 = list(string)<br>    level2 = list(object({<br>      name   = string<br>      parent = string<br>    }))<br>    level3 = list(object({<br>      name   = string<br>      parent = string<br>    }))<br>    level4 = list(object({<br>      name   = string<br>      parent = string<br>    }))<br>    level5 = list(object({<br>      name   = string<br>      parent = string<br>    }))<br>  })</pre> | n/a | yes |
| <a name="input_org_parent_folder"></a> [org\_parent\_folder](#input\_org\_parent\_folder) | Parent folder on organization level for all nested child folders | `string` | `""` | no |
| <a name="input_skip_gcloud_download"></a> [skip\_gcloud\_download](#input\_skip\_gcloud\_download) | If set to false the gcloud binaries will be downloaded. Use for Terraform Cloud | `bool` | `true` | no |
| <a name="input_terraform_service_accounts"></a> [terraform\_service\_accounts](#input\_terraform\_service\_accounts) | List of terraform service accounts to be created. Create a terraform service account for each environment folder | `list(string)` | <pre>[<br>  "us-dev",<br>  "us-stg",<br>  "us-prd",<br>  "eu-dev",<br>  "eu-stg",<br>  "eu-prd"<br>]</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_admin_folder"></a> [admin\_folder](#output\_admin\_folder) | Admin Folder ID |
| <a name="output_admin_terraform_state_bucket"></a> [admin\_terraform\_state\_bucket](#output\_admin\_terraform\_state\_bucket) | Bucket where the state file for this module will be stored |
| <a name="output_folders"></a> [folders](#output\_folders) | Folder objects |
| <a name="output_project_id"></a> [project\_id](#output\_project\_id) | Admin Project ID |
| <a name="output_state_buckets"></a> [state\_buckets](#output\_state\_buckets) | Mapping of the environment and bucket name |
| <a name="output_terraform_sa_accounts"></a> [terraform\_sa\_accounts](#output\_terraform\_sa\_accounts) | Terraform Service Accounts |

[^]: (autogen_docs_end)
