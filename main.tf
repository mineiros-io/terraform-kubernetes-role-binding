resource "kubernetes_cluster_role_binding" "role" {
  count = var.module_enabled && var.is_cluster_role ? 1 : 0

  depends_on = [var.module_depends_on]

  metadata {
    annotations = var.annotations
    labels      = var.labels
    name        = var.name
  }

  role_ref {
    name      = var.role_ref_name
    kind      = var.role_ref_kind
    api_group = var.role_ref_api_group
  }

  dynamic "subject" {
    for_each = var.subjects

    content {
      name      = subject.value.name
      namespace = try(subject.value.namespace, null)
      kind      = subject.value.kind
      api_group = subject.value.api_group
    }
  }
}

resource "kubernetes_role_binding" "role" {
  count = var.module_enabled && var.is_cluster_role ? 0 : 1

  depends_on = [var.module_depends_on]

  metadata {
    annotations = var.annotations
    labels      = var.labels
    name        = var.name
    namespace   = var.namespace
  }

  role_ref {
    name      = var.role_ref_name
    kind      = var.role_ref_kind
    api_group = var.role_ref_api_group
  }

  dynamic "subject" {
    for_each = var.subjects

    content {
      name      = subject.value.name
      namespace = try(subject.value.namespace, null)
      kind      = subject.value.kind
      api_group = try(subject.value.api_group, null)
    }
  }
}
