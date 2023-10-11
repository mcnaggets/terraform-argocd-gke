provider "kubernetes" {
  host           = var.kube_host
  config_path    = "~/.kube/config"
  config_context = var.kube_config_context
}

provider "helm" {
  kubernetes {
    host           = var.kube_host
    config_path    = "~/.kube/config"
    config_context = var.kube_config_context
  }
}

provider "kubectl" {
  host           = var.kube_host
  config_path    = "~/.kube/config"
  config_context = var.kube_config_context
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


