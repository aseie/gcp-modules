# Audit
This module creates the audit project where audit logs will be collected. The module will:
* Create audit project
* Create BQ Dataset for logs
* Create organization log sink

# Example terragrunt.hcl usage
```hcl
terraform {
  source = "../../modules/audit"
}

locals {
  common_vars   = yamldecode(file(find_in_parent_folders("${local.environment}.yaml")))
  environment   = basename(dirname(get_terragrunt_dir()))
  resource      = basename(get_terragrunt_dir())
  resource_vars = local.common_vars["Resources"]["${local.resource}"]
}

inputs = merge(local.resource_vars["inputs"], {
  log_sink_parent          = local.common_vars.common.root_folder
  log_sink_parent_type     = "folder"
  location                 = "us-east4"
  audit_folder             = false
  audit_folder_name        = local.environment
  audit_folder_id          = dependency.core.outputs.admin_folder
  random_project_id        = false
})

dependency "core" {
  config_path = "../core"
}

include {
  path = find_in_parent_folders()
}
```

[^]: (autogen_docs_start)
## Providers

| Name | Version |
|------|---------|
| google | ~> 3.30 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| audit\_folder | Wheater to create audit folder or not | `bool` | `true` | no |
| audit\_folder\_name | Name of the audit folder if audit\_folder = true | `string` | `"audit"` | no |
| billing\_account | Billing Account | `string` | n/a | yes |
| dataset\_description | A use-friendly description of the dataset | `string` | `"Log export dataset"` | no |
| dataset\_labels | BQ Dataset labels | `map(string)` | `{}` | no |
| dataset\_location | BQ Dataset location (US, EU, etc...) | `string` | n/a | yes |
| dataset\_name | BQ Dataset name where logs will be pushed to | `string` | `"audit_logs"` | no |
| default\_table\_expiration\_ms | Default table expiration time (in ms). Default is 1 year | `number` | `31708800000` | no |
| domain | Organization domain | `string` | n/a | yes |
| log\_sink\_name | Log sink name | `string` | `"organization_sink"` | no |
| skip\_gcloud\_download | If set to false the gcloud binaries will be downloaded. Use for Terraform Cloud | `bool` | `true` | no |

## Outputs

| Name | Description |
|------|-------------|
| bq\_resource\_id | The resource id for the destination bigquery dataset |
| bq\_resource\_name | The resource name for the destination bigquery dataset |
| bq\_self\_link | The self\_link URI for the destination bigquery dataset |
| console\_link | The console link to the destination bigquery dataset |
| destination\_uri | BQ Dataset URI |
| log\_filter | Log filter expression |
| log\_sink\_sa | Service account name of the log sink |
| project\_id | Audit Project ID |


[^]: (autogen_docs_end)
