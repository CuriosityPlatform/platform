resource "helm_release" "gitea" {
  name = "gitea"

  wait = "true"

  namespace        = "gitea"
  create_namespace = true

  repository = "https://dl.gitea.com/charts"
  chart      = "gitea"

  # Gitea
  ## Actions
  set {
    name  = "actions.enabled"
    value = "true"
  }
  set {
    name  = "actions.provisioning.enabled"
    value = "true"
  }

  # Persistence
  ## Explicitly enable PostgreSQL
  set {
    name  = "postgresql.enabled"
    value = "true"
  }
  ## Disable HA PostgreSQL
  set {
    name  = "postgresql-ha.enabled"
    value = "false"
  }
  ## Disable Redis
  set {
    name  = "redis.enabled"
    value = "false"
  }
}