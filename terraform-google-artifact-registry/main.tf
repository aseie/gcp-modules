resource "google_artifact_registry_repository" "this" {
  provider      = google-beta
  project       = var.project_id
  location      = var.region
  repository_id = var.repository_id
  description   = var.repository_description
  format        = var.repository_format
  labels        = var.labels
}

resource "google_artifact_registry_repository_iam_member" "readonly" {
  for_each   = var.permission_readonly
  provider   = google-beta
  project    = var.project_id
  location   = google_artifact_registry_repository.this.location
  repository = google_artifact_registry_repository.this.name
  role       = "roles/artifactregistry.reader"
  member     = each.value
}

resource "google_artifact_registry_repository_iam_member" "readwrite" {
  for_each   = var.permission_readwrite
  provider   = google-beta
  project    = var.project_id
  location   = google_artifact_registry_repository.this.location
  repository = google_artifact_registry_repository.this.name
  role       = "roles/artifactregistry.writer"
  member     = each.value
}

resource "google_project_service" "containerscanning" {
  count                      = var.enable_scanning == true ? 1 : 0
  project                    = var.project_id
  service                    = "containerscanning.googleapis.com"
  disable_dependent_services = true
}


#---- Grant Read Access to [Google Cloud Run Service Agent] by Project ID-------
resource "google_project_service_identity" "cloudrun" {
  for_each = var.projects_cloudrun_agent_read_access
  provider = google-beta
  project  = each.value
  service  = "run.googleapis.com"
}

resource "google_artifact_registry_repository_iam_member" "cloudrun_read" {
  for_each   = var.projects_cloudrun_agent_read_access
  provider   = google-beta
  project    = var.project_id
  location   = google_artifact_registry_repository.this.location
  repository = google_artifact_registry_repository.this.name
  role       = "roles/artifactregistry.reader"
  member     = "serviceAccount:${google_project_service_identity.cloudrun[each.value].email}"

  depends_on = [google_project_service_identity.cloudrun]
}
