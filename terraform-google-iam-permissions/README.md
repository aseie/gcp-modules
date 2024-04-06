# iam-permissions
This module is in charge of setting permissions on all levels and attaching service projects to shared vpc. This means
that you can use this module to set permissions on organization, folder, project, subnetwork, storage bucket, and
service_accounts.

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
| <a name="module_folder_iam"></a> [folder\_iam](#module\_folder\_iam) | terraform-google-modules/iam/google//modules/folders_iam | 6.4.1 |
| <a name="module_organization_iam"></a> [organization\_iam](#module\_organization\_iam) | terraform-google-modules/iam/google//modules/organizations_iam | 6.4.1 |
| <a name="module_project_iam"></a> [project\_iam](#module\_project\_iam) | terraform-google-modules/iam/google//modules/projects_iam | 6.4.1 |
| <a name="module_service_account_iam"></a> [service\_account\_iam](#module\_service\_account\_iam) | terraform-google-modules/iam/google//modules/service_accounts_iam | 6.4.1 |
| <a name="module_storage_buckets_iam"></a> [storage\_buckets\_iam](#module\_storage\_buckets\_iam) | terraform-google-modules/iam/google//modules/storage_buckets_iam | 6.4.1 |
| <a name="module_subnet_iam"></a> [subnet\_iam](#module\_subnet\_iam) | terraform-google-modules/iam/google//modules/subnets_iam | 6.4.1 |
| <a name="module_workload_identity_iam"></a> [workload\_identity\_iam](#module\_workload\_identity\_iam) | ./modules/workload_identity_iam | n/a |

## Resources

| Name | Type |
|------|------|
| [google_compute_shared_vpc_service_project.shared_vpc_attachments](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_shared_vpc_service_project) | resource |
| [google_organization.org](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/organization) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_folders_iam"></a> [folders\_iam](#input\_folders\_iam) | Structure describing role bindings for folders | <pre>map(object({<br>    bindings = map(list(string))<br>  }))</pre> | `{}` | no |
| <a name="input_organizations_iam"></a> [organizations\_iam](#input\_organizations\_iam) | Structure describing role bindings for organizations. Mapping is done via domain. Example: {example.com = {bindings = {roles/owner = ["user:ab@example.com"]}}} | <pre>map(object({<br>    bindings = map(list(string))<br>  }))</pre> | `{}` | no |
| <a name="input_projects_iam"></a> [projects\_iam](#input\_projects\_iam) | Structure describing role bindings for projects | <pre>map(object({<br>    bindings = map(list(string))<br>  }))</pre> | `{}` | no |
| <a name="input_service_accounts_iam"></a> [service\_accounts\_iam](#input\_service\_accounts\_iam) | Structure describing role bindings for service accounts. Example: { "terraform-eu-stg@administration-4082.iam.gserviceaccount.com" = {bindings = {roles/iam.serviceAccountTokenCreator = ["user:ab@example.com"]}, project = "admin-123"}} | <pre>map(object({<br>    bindings = map(list(string)),<br>    project  = string<br>  }))</pre> | `{}` | no |
| <a name="input_shared_vpc_attachments"></a> [shared\_vpc\_attachments](#input\_shared\_vpc\_attachments) | Map of the projects that should be attached to host project. Key = Host Project, Value = List of service projects | `map(list(string))` | `{}` | no |
| <a name="input_storage_buckets_iam"></a> [storage\_buckets\_iam](#input\_storage\_buckets\_iam) | Structure describing role bindings for storage buckets. | <pre>map(object({<br>    bindings = map(list(string))<br>  }))</pre> | `{}` | no |
| <a name="input_subnets_iam"></a> [subnets\_iam](#input\_subnets\_iam) | Structure describing role bindings for subnets. Subnets have to be defined as self\_links. Example: {"projects/robin-sandbox-260523/regions/us-west1/subnetworks/gke-subnet" = {bindings = {roles/compute.networkAdmin = ["user:ab@example.com"]}}} | <pre>map(object({<br>    bindings = map(list(string))<br>  }))</pre> | `{}` | no |
| <a name="input_workload_identity_iam"></a> [workload\_identity\_iam](#input\_workload\_identity\_iam) | n/a | <pre>map(object({<br>    namespace   = string,<br>    k8s_sa_name = string<br>    project     = string,<br>    roles       = list(string)<br>  }))</pre> | `{}` | no |

## Outputs

No outputs.

[^]: (autogen_docs_end)

# Example terragrunt.hcl usage
```hcl
locals {
  env_folder = "folders/11111"
  tf_service_account = "terraform-eu-prd@administration-4082.iam.gserviceaccount.com"
}

inputs = {
  organizations_iam = {
    "opsguru.io" = {
      bindings = {
        "roles/resourcemanager.organizationViewer" = [
          "serviceAccount:${local.tf_service_account}",
        ]
        "roles/resourcemanager.projectCreator" = [
          "serviceAccount:${local.tf_service_account}",
        ]
      }
    }
  }

  folders_iam = {
    "${local.env_folder}" = {
      bindings = {
        "roles/resourcemanager.folderAdmin" = [
          "serviceAccount:${local.tf_service_account}"]
        "roles/compute.xpnAdmin" = [
          "serviceAccount:${local.tf_service_account}"]
      }
    }
  }
  
  service_accounts_iam = {
    "${local.tf_service_account}" = {
      bindings = {
        "roles/iam.serviceAccountTokenCreator" = ["user:marko@opsguru.io"]
      }
      project = "admin-1123"
    }
  }
}
```
