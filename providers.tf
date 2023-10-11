locals {
  gke_host         = length(data.terraform_remote_state.gke_cluster.outputs) > 0 ? "https://${data.terraform_remote_state.gke_cluster.outputs.endpoint}" : "localhost"
  kube_config_path = "~/.kube/config"
  kube_context     = "gke_${var.project_id}_${var.region}_${var.cluster_name}-${var.region}"
}

provider "kubernetes" {
  host           = local.gke_host
  config_path    = local.kube_config_path
  config_context = local.kube_context
}

provider "helm" {
  kubernetes {
    host           = local.gke_host
    config_path    = local.kube_config_path
    config_context = local.kube_context
  }
}

provider "kubectl" {
  source         = "gavinbunney/kubectl"
  host           = local.gke_host
  config_path    = local.kube_config_path
  config_context = local.kube_context
}


