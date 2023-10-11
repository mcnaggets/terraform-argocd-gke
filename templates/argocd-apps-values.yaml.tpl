applications:
  - name: managed-fusion-applications
    namespace: argocd
    project: default
    source:
      repoURL: ${repoURL}
      targetRevision: HEAD
      path: ${clusterType}/applications
      directory:
        recurse: true
    destination:
      name: in-cluster
      namespace: argocd
    syncPolicy:
      automated:
        prune: true
        selfHeal: true
