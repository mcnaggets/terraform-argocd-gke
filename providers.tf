locals {
  kube_config_path    = "~/.kube/config"
  kube_config_context = "gke_${var.project_id}_${var.region}_${var.cluster_name}-${var.region}"
}

provider "kubernetes" {
  host           = var.kube_host
  config_path    = local.kube_config_path
  config_context = local.kube_config_context
}

provider "helm" {
  kubernetes {
    host           = var.kube_host
    config_path    = local.kube_config_path
    config_context = local.kube_config_context
  }
}

provider "kubectl" {
  host           = var.kube_host
  config_path    = local.kube_config_path
  config_context = local.kube_config_context
}

provider "github" {
  owner = var.github_owner
}

terraform {
  required_providers {
    kubectl = {
      source = "gavinbunney/kubectl"
    }
  }
}


