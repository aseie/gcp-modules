variable "billing_account" {
  description = "Billing Account"
  type        = string
}

variable "domain" {
  description = "Organization domain"
  type        = string
}

variable "audit_folder" {
  description = "Wheater to create audit folder or not"
  type        = bool
  default     = true
}

variable "audit_folder_name" {
  description = "Name of the audit folder if audit_folder = true"
  type        = string
}

variable "audit_project_name" {
  type = string
}

variable "audit_project_id" {
  type = string
}

variable "audit_random_project_id" {
  type    = bool
  default = false
}

variable "org_parent_folder" {
  description = "Parent folder on organization level for all nested child folders"
  type        = string
  default     = ""
}

variable "log_sink_name" {
  description = "Log sink name"
  type        = string
  default     = "organization_sink"
}

variable "log_sink_parent" {
  description = "Entity name to sink logs from. Type is one of the following: 'project', 'folder', 'billing_account', or 'organization'"
  type        = string
  default     = ""
}

variable "log_sink_parent_type" {
  description = "The GCP resource in which you create the log sink. Must be one of the following: 'project', 'folder', 'billing_account', or 'organization'"
  type        = string
  default     = "organization"
}

variable "skip_gcloud_download" {
  description = "If set to false the gcloud binaries will be downloaded. Use for Terraform Cloud"
  type        = bool
  default     = true
}

variable "topic_name" {
  description = "The name of the pubsub topic to be created and used for log entries matching the filter."
  type        = string
  default     = "audit_logs"
}

variable "create_log_export" {
  description = "Whether to add a push configuration to the subcription. If 'true', a push subscription is created along with a service account that is granted roles/pubsub.subscriber and roles/pubsub.viewer to the topic."
  type        = bool
  default     = false
}

variable "activate_apis" {
  description = "List og GPC project apis to be activated"
  type        = list(string)
  default     = []
}

variable "audit_folder_id" {
  description = "Audit folder ID"
  type        = string
  default     = ""
}

variable "location" {
  default = "us-east4"
}
