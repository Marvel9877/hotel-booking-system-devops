# Frontend ConfigMap
resource "kubernetes_config_map" "frontend" {
  metadata {
    name      = "frontend-config"
    namespace = kubernetes_namespace.app.metadata[0].name
  }

  data = {
    REACT_APP_API_URL = "http://backend:5000/api"
  }
}

# Frontend Deployment
resource "kubernetes_deployment" "frontend" {
  metadata {
    name      = "frontend"
    namespace = kubernetes_namespace.app.metadata[0].name
    labels = {
      app = "frontend"
    }
  }

  spec {
    replicas = var.frontend_replicas

    selector {
      match_labels = {
        app = "frontend"
      }
    }

    template {
      metadata {
        labels = {
          app = "frontend"
        }
      }

      spec {
        container {
          name  = "frontend"
          image = var.frontend_image
          image_pull_policy = "Always"

          port {
            container_port = 80
            name           = "http"
          }

          env {
            name = "REACT_APP_API_URL"
            value_from {
              config_map_key_ref {
                name = kubernetes_config_map.frontend.metadata[0].name
                key  = "REACT_APP_API_URL"
              }
            }
          }

          resources {
            requests = {
              memory = "128Mi"
              cpu    = "100m"
            }
            limits = {
              memory = "256Mi"
              cpu    = "300m"
            }
          }

          liveness_probe {
            http_get {
              path = "/"
              port = 80
            }
            initial_delay_seconds = 30
            period_seconds        = 10
            timeout_seconds       = 5
            failure_threshold     = 3
          }

          readiness_probe {
            http_get {
              path = "/"
              port = 80
            }
            initial_delay_seconds = 10
            period_seconds        = 5
            timeout_seconds       = 3
            failure_threshold     = 3
          }
        }

        # Wait for backend to be ready
        init_container {
          name  = "wait-for-backend"
          image = "busybox:1.35"
          command = [
            "sh",
            "-c",
            "until nc -z backend 5000; do echo waiting for backend; sleep 2; done"
          ]
        }
      }
    }
  }

  depends_on = [
    kubernetes_service.backend,
    kubernetes_config_map.frontend
  ]
}

# Frontend Service
resource "kubernetes_service" "frontend" {
  metadata {
    name      = "frontend"
    namespace = kubernetes_namespace.app.metadata[0].name
    labels = {
      app = "frontend"
    }
  }

  spec {
    selector = {
      app = "frontend"
    }

    port {
      port        = 80
      target_port = 80
      protocol    = "TCP"
      name        = "http"
    }

    type = "LoadBalancer"
  }

  depends_on = [kubernetes_deployment.frontend]
}
