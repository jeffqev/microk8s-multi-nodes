provider "kubernetes" {
  config_path = "~/.kube/config"
}

resource "kubernetes_namespace" "nest" {
  metadata {
    name = var.app_ns
  }
}

resource "kubernetes_deployment" "backend-nest" {
  metadata {
    name      = var.app_name
    namespace = kubernetes_namespace.nest.metadata.0.name
    labels = {
      app = var.app_label
    }
  }

  spec {
    replicas = var.replicas

    selector {
      match_labels = {
        app = var.app_label
      }
    }

    template {
      metadata {
        labels = {
          app = var.app_label
        }
      }

      spec {
        container {
          image = var.app_image
          name  = var.app_name
        }
      }
    }
  }
}

resource "kubernetes_service" "backend-nest" {
  metadata {
    name      = var.app_name
    namespace = kubernetes_namespace.nest.metadata.0.name

  }
  spec {
    selector = {
      app = "${kubernetes_deployment.backend-nest.metadata.0.labels.app}"
    }

    port {
      port        = var.service.port
      target_port = var.service.target_port
    }

    type = var.service.type
  }
}
