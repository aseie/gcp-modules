data "google_organization" "org" {
  domain = var.domain
}

locals {
  service_accounts = flatten([
    for project, project_config in var.service_projects : [
      for sa in project_config.service_accounts : "${sa}--${project}"
  ]])
  project_outputs = var.service_projects != {} ? { for project, _ in var.service_projects : project => module.service_project[project] } : {}
  vpc_outputs     = var.vpcs != {} ? { for project, _ in var.vpcs : project => module.vpc[project] } : {}
  api_outputs     = var.service_projects != {} ? { for project, _ in var.service_projects : project => module.active_apis[project] } : {}
  sa_outputs = { for project, _ in var.service_projects :
    project => { for sa in google_service_account.service_accounts :
      sa.account_id => sa.email if sa.project == module.service_project[project].project_id
  } }
  key_outputs = var.kms_rings != {} ? { for project, _ in var.kms_rings : project => module.kms_rings[project] } : {}
}

module "service_project" {
  for_each                    = var.service_projects
  source                      = "terraform-google-modules/project-factory/google"
  version                     = "~> 14.2"
  name                        = var.service_projects[each.key].project_name
  random_project_id           = var.service_projects[each.key].random_project_id
  org_id                      = data.google_organization.org.org_id
  folder_id                   = var.service_projects[each.key].folder_id
  billing_account             = var.billing_account
  default_service_account     = var.service_projects[each.key].default_service_account
  lien                        = var.service_projects[each.key].lien
  disable_dependent_services  = var.service_projects[each.key].disable_dependent_services
  disable_services_on_destroy = var.service_projects[each.key].disable_services_on_destroy
  svpc_host_project_id        = var.service_projects[each.key].shared_vpc_host_name
  shared_vpc_subnets          = var.service_projects[each.key].shared_vpc_subnets
}

resource "google_service_usage_consumer_quota_override" "quota" {
  for_each       = var.project_quotas
  provider       = google-beta
  project        = module.service_project[each.key].project_id
  service        = each.value.service
  metric         = "${each.value.service}%2F${each.value.metric}" # "servicemanagement.googleapis.com%2Fdefault_requests" "compute.googleapis.com%2Finternal_addresses"
  limit          = each.value.limit # "%2Fmin%2Fproject"
  override_value = each.value.override_value
  force          = true
}

module "active_apis" {
  for_each      = var.service_projects
  source        = "terraform-google-modules/project-factory/google//modules/project_services"
  version       = "~> 14.2"
  activate_apis = var.service_projects[each.key].active_apis
  project_id    = module.service_project[each.key].project_id
  depends_on    = [module.service_project]
}

module "vpc" {
  for_each                               = var.vpcs
  source                                 = "terraform-google-modules/network/google"
  version                                = "~> 7.1"
  project_id                             = module.service_project[each.key].project_id
  network_name                           = each.value.network_name
  delete_default_internet_gateway_routes = false
  subnets                                = each.value.subnets
  secondary_ranges                       = each.value.secondary_ranges
  depends_on = [
    module.service_project,
    module.active_apis,
  ]
}

resource "google_compute_global_address" "private" {
  for_each      = var.vpcs
  provider      = google-beta
  project       = module.service_project[each.key].project_id
  name          = "private-${module.service_project[each.key].project_id}"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = module.vpc[each.key].network_self_link
  depends_on = [
    module.service_project,
    module.vpc,
  ]
}

resource "google_service_networking_connection" "private_vpc_connection" {
  for_each                = var.vpcs
  provider                = google-beta
  network                 = module.vpc[each.key].network_self_link
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private[each.key].name]
}

resource "google_service_account" "service_accounts" {
  for_each   = toset(distinct(local.service_accounts))
  project    = module.service_project[split("--", each.key).1].project_id
  account_id = split("--", each.key)[0]
}

# Cloudkms vault key ring
module "kms_rings" {
  for_each = var.kms_rings
  source   = "terraform-google-modules/kms/google"
  version  = "~> 2.2"

  project_id     = module.service_project[each.key].project_id
  location       = var.kms_rings[each.key].location
  keyring        = var.kms_rings[each.key].keyring
  keys           = var.kms_rings[each.key].keys
  set_owners_for = var.kms_rings[each.key].set_owners_for
  owners         = var.kms_rings[each.key].owners
}

module "project_iam" {
  for_each = toset(var.gke_iam)
  source   = "terraform-google-modules/iam/google//modules/projects_iam"
  version  = "~> 7.6"
  projects = var.gke_iam_projects
  mode     = "additive"
  bindings = {
    "roles/container.hostServiceAgentUser" = [
      "serviceAccount:service-${module.service_project[each.key].project_number}@container-engine-robot.iam.gserviceaccount.com",
    ],
    "roles/compute.networkUser" = [
      "serviceAccount:service-${module.service_project[each.key].project_number}@container-engine-robot.iam.gserviceaccount.com",
    ]
  }
}
