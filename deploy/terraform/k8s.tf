provider "kubernetes" {
  config_path = "~/.kube/config"
}

resource "kubernetes_namespace" "nest" {
  metadata {
    name = "nest-app"
  }
}

resource "kubernetes_deployment" "backend-nest" {
  metadata {
    name      = "backend-nest"
    namespace = kubernetes_namespace.nest.metadata.0.name
    labels = {
      app = "nest"
    }
  }

  spec {
    replicas = 3

    selector {
      match_labels = {
        app = "nest"
      }
    }

    template {
      metadata {
        labels = {
          app = "nest"
        }
      }

      spec {
        container {
          image = "jeffqev/ci-nest:main"
          name  = "backend-nest"
        }
      }
    }
  }
}

resource "kubernetes_service" "backend-nest" {
  metadata {
    name      = "backend-nest"
    namespace = kubernetes_namespace.nest.metadata.0.name

  }
  spec {
    selector = {
      app = "${kubernetes_deployment.backend-nest.metadata.0.labels.app}"
    }

    port {
      port        = 80
      target_port = 3000
    }

    type = "NodePort"
  }
}
