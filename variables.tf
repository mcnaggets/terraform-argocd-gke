variable "region" {
  type    = string
  default = "us-central1"
}

variable "project_id" {
  type = string
}

variable "cluster_name" {
  type = string
}

variable "cluster_type" {
  type = string
}

variable "repo_name" {
  type = string
}

variable "argocd_host" {
  type = string
}

variable "argocd_host_tls_name" {
  type = string
}

variable "kube_host" {
  type = string
}

variable "slack_notification_bot_token" {
  type        = string
  description = "The oauth token for the slack notification bot"
}

variable "fusion_dev_helm_repo_username" {
  type        = string
  description = "The username for the fusion-dev-helm artifactory repo"
}

variable "fusion_dev_helm_repo_password" {
  type        = string
  description = "The password for the fusion-dev-helm artifactory repo"
}

variable "okta_client_id" {
  type        = string
  description = "The okta app client id to use for oauth"
}

variable "okta_client_secret" {
  type        = string
  description = "The okta app client secret to use for oauth"
}

variable "config_sync_private_key" {
  type        = string
  description = "The confyg-sync repo private key"
}

variable "config_sync_public_key" {
  type        = string
  description = "The confyg-sync repo public key"
}

variable "github_owner" {
  type        = string
  description = "The lucidworks-managed-fusion user for github"
}

variable "github_token" {
  type        = string
  description = "The lucidworks-managed-fusion password for github"
}
