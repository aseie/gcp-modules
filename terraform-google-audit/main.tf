data "google_organization" "org" {
  domain = var.domain
}

data "google_folder" "org_parent_folder" {
  count               = var.org_parent_folder != "" ? 1 : 0
  folder              = var.org_parent_folder
  lookup_organization = false
}

resource "google_folder" "audit_folder" {
  count        = var.audit_folder ? 1 : 0
  display_name = var.audit_folder_name
  parent       = var.org_parent_folder != "" ? data.google_folder.org_parent_folder.0.id : data.google_organization.org.name
}

module "audit_project" {
  source                     = "terraform-google-modules/project-factory/google"
  version                    = "~> 14.0"
  name                       = var.audit_project_name
  project_id                 = var.audit_project_id
  random_project_id          = var.audit_random_project_id
  org_id                     = data.google_organization.org.org_id
  folder_id                  = var.audit_folder ? google_folder.audit_folder.0.name : var.audit_folder_id
  billing_account            = var.billing_account
  default_service_account    = "deprivilege"
  lien                       = true
  disable_dependent_services = true
  activate_apis              = var.activate_apis
}

module "log_export" {
  count                  = var.create_log_export ? 1 : 0
  source                 = "terraform-google-modules/log-export/google"
  version                = "~> 7.6"
  destination_uri        = module.destination.0.destination_uri
  filter                 = "logName:\"logs/cloudaudit.googleapis.com\""
  log_sink_name          = var.log_sink_name
  parent_resource_id     = var.log_sink_parent != "" ? var.log_sink_parent : module.audit_project.project_id #The ID of the project in which BigQuery dataset destination will be created
  parent_resource_type   = var.log_sink_parent_type
  unique_writer_identity = true
  include_children       = true
}

module "destination" {
  count                    = var.create_log_export ? 1 : 0
  source                   = "terraform-google-modules/log-export/google//modules/bigquery"
  version                  = "~> 7.6"
  project_id               = module.audit_project.project_id #The ID of the project in which the log export will be created.
  dataset_name             = var.topic_name
  location                 = var.location
  log_sink_writer_identity = module.log_export.0.writer_identity
}
