resource "tls_private_key" "identity" {
  algorithm   = "ECDSA"
  ecdsa_curve = "P521"
}

resource "random_password" "github_webhook_secret" {
  length           = 16
  special          = true
  override_special = "_%@"
}

resource "github_repository_deploy_key" "main" {
  title      = "argocd-${var.repo_name}-main"
  repository = var.repo_name
  key        = tls_private_key.identity.public_key_openssh
  read_only  = true
}

resource "github_repository_webhook" "argocd" {
  repository = var.repo_name
  events     = ["push"]
  configuration {
    url          = "https://${var.argocd_host}/api/webhook"
    content_type = "json"
    secret       = random_password.github_webhook_secret.result
  }
}

resource "helm_release" "argocd" {
  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  version          = "5.46.7"
  namespace        = "argocd"
  create_namespace = true

  values = [
    templatefile(
      "${path.module}/templates/argocd-values.yaml.tpl",
      {
        "repoName"                  = var.repo_name
        "repoURL"                   = "git@github.com:lucidworks-managed-fusion/${var.repo_name}.git"
        "repoSshPrivateKey"         = jsonencode(tls_private_key.identity.private_key_pem)
        "repoSshPublicKey"          = tls_private_key.identity.public_key_openssh
        "clusterType"               = var.cluster_type
        "fusionDevHelmRepoUsername" = var.fusion_dev_helm_repo_username
        "fusionDevHelmRepoPassword" = var.fusion_dev_helm_repo_password
        "argocdHost"                = var.argocd_host
        "argocdHostTlsName"         = var.argocd_host_tls_name
        "githubWebhookSecret"       = random_password.github_webhook_secret.result
        "oktaClientID"              = var.okta_client_id
        "oktaClientSecret"          = var.okta_client_secret
        "configSyncRepoURL"         = "git@github.com:lucidworks-managed-fusion/cloud-support-config.git"
        "configSyncSshPrivateKey"   = jsonencode(var.config_sync_private_key)
        "configSyncSshPublicKey"    = var.config_sync_public_key
        "managedFusionHelmUser"     = var.github_owner
        "managedFusionHelmPassword" = var.github_token
      }
    ),
    templatefile(
      "${path.module}/templates/argocd-applicationset-values.yaml.tpl",
      {
      }
    ),
    templatefile(
      "${path.module}/templates/argocd-notifications-values.yaml.tpl",
      {
        "slackNotificationBotToken" = var.slack_notification_bot_token
      }
    )
  ]
}

resource "helm_release" "argocd-apps" {
  name             = "argocd-apps"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argocd-apps"
  version          = "1.4.1"
  namespace        = "argocd"
  create_namespace = true

  values = [
    templatefile(
      "${path.module}/templates/argocd-apps-values.yaml.tpl",
      {
        "repoURL"     = "git@github.com:lucidworks-managed-fusion/${var.repo_name}.git"
        "clusterType" = var.cluster_type
      }
    )
  ]

  depends_on = [
    helm_release.argocd
  ]
}