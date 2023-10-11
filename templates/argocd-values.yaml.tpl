controller:
  enableStatefulSet: true
  logformat: json
  nodeSelector:
    fusion_node_type: infra
  metrics:
    enabled: true

redis:
  nodeSelector:
    fusion_node_type: infra

server:
  nodeSelector:
    fusion_node_type: infra
  metrics:
    enabled: true
  ingress:
    enabled: true
    https: true
    annotations:
      kubernetes.io/ingress.class: nginx
      cert-manager.io/cluster-issuer: letsencrypt-production
      nginx.ingress.kubernetes.io/backend-protocol: "HTTPS"
      nginx.ingress.kubernetes.io/ssl-passthrough: "true"
    hosts:
      - ${argocdHost}
    tls:
      - secretName: ${argocdHostTlsName}
        hosts:
          - ${argocdHost}
  config:
    admin.enabled: "false"
    url: https://${argocdHost}
    resource.exclusions: |
      - apiGroups:
        - "velero.io"
        kinds:
        - Backup
        clusters:
        - "*"
    oidc.config: |
      name: Okta
      issuer: https://lucidworks.okta.com/oauth2/default
      clientID: ${oktaClientID}
      clientSecret: ${oktaClientSecret}
      requestedIDTokenClaims:
        groups:
          essential: true
      requestedScopes:
        - "openid"
        - "profile"
        - "email"
        - "groups"
      logoutURL: https://${argocdHost}
  rbacConfig:
    policy.default: role:readonly
    policy.csv: |
      g, cc_ops, role:admin
      g, cc_cloud_ops, role:admin
    scopes: "[groups, email]"
repoServer:
  nodeSelector:
    fusion_node_type: infra
  metrics:
    enabled: true

dex:
  enabled: false

configs:
  credentialTemplates:
    ${repoName}:
      url: ${repoURL}
      sshPrivateKey: ${repoSshPrivateKey}
      sshPublicKey: ${repoSshPublicKey}
    cloud-support-config:
      url: ${configSyncRepoURL}
      sshPrivateKey: ${configSyncSshPrivateKey}
      sshPublicKey: ${configSyncSshPublicKey}
    managed-fusion-helm:
      url:  https://lucidworks-managed-fusion.github.io/helm-charts
      username: ${managedFusionHelmUser}
      password: ${managedFusionHelmPassword}
    fusion-dev-helm-v2:
      url: https://artifactory.lucidworks.com:443/artifactory/api/helm/fusion-dev-helm
      username: ${fusionDevHelmRepoUsername}
      password: ${fusionDevHelmRepoPassword}
    fusion-dev-helm-v1:
      url: https://ci-artifactory.lucidworks.com:443/artifactory/fusion-dev-helm
      username: ${fusionDevHelmRepoUsername}
      password: ${fusionDevHelmRepoPassword}
  repositories:
    ${repoName}:
      url: ${repoURL}
      name: ${repoName}
      type: git
    cloud-support-config:
      url: ${configSyncRepoURL}
      name: cloud-support-config
      type: git
    fusion-dev-helm-v2:
      url: https://artifactory.lucidworks.com:443/artifactory/api/helm/fusion-dev-helm
      name: fusion-dev-helm-v2
      type: helm
    fusion-dev-helm-v1:
      url: https://ci-artifactory.lucidworks.com:443/artifactory/fusion-dev-helm
      name: fusion-dev-helm-v1
      type: helm
    managed-fusion-helm:
      url:  https://lucidworks-managed-fusion.github.io/helm-charts
      name: managed-fusion-helm
      type: helm
  secret:
    githubSecret: "${githubWebhookSecret}"