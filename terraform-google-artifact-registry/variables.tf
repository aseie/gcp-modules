variable "project_id" {
  description = "Project ID where to create Artifact Registry"
  type        = string
}

variable "region" {
  description = "Region where to create Artifact Registry"
  type        = string
}

variable "repository_id" {
  description = "The last part of the repository name"
  type        = string
  default     = "docker_repository"
}

variable "repository_description" {
  description = "Description of Artifact Registry"
  type        = string
  default     = "Artifact Registry"
}

variable "repository_format" {
  description = "The format of packages: DOCKER, MAVEN, NPM, PYTHON, APT, YUM"
  type        = string
  default     = "DOCKER"
}

variable "labels" {
  description = "Labels with user-defined metadata"
  type        = map(any)
  default     = {}
}

variable "kms_key_name" {
  description = "The Cloud KMS resource name of the customer managed encryption key"
  type        = string
  default     = ""
}

variable "permission_readonly" {
  description = "List of IAM Members to attach Read Only Permission"
  type        = set(string)
  default     = []
}

variable "permission_readwrite" {
  description = "List of IAM Members to attach Read/Write permission"
  type        = set(string)
  default     = []
}

variable "enable_scanning" {
  description = "Enable Container Vulnerability scanning"
  type        = bool
  default     = true
}

variable "projects_cloudrun_agent_read_access" {
  description = "List of Project IDs to allow Read access for Google Cloud Run Service Agent"
  type        = set(string)
  default     = []
}
