# Reddit-app instance group
resource "google_compute_instance_group" "reddit-app-grp" {
  name        = "reddit-app-grp"
  description = "Instance group for reddit-app instances"

  # Example: google_compute_instance.app.N.self_link;
  # where N - instance index

  instances = ["${google_compute_instance.app.*.self_link}"]
  named_port {
    name = "reddit-app-port"
    port = "${var.app_port}"
  }
  zone = "${var.zone}"
}

# LoadBalancer settings

### Health check
resource "google_compute_http_health_check" "reddit-app-health-check" {
  name               = "reddit-app-health-check"
  request_path       = "/"
  port               = "${var.app_port}"
  check_interval_sec = 1
  timeout_sec        = 1
}

### Backend service
resource "google_compute_backend_service" "reddit-app-backend" {
  name        = "reddit-app-backend"
  port_name   = "reddit-app-port"
  protocol    = "HTTP"
  timeout_sec = 5

  backend {
    group = "${google_compute_instance_group.reddit-app-grp.self_link}"
  }

  health_checks = ["${google_compute_http_health_check.reddit-app-health-check.self_link}"]
}

### Forwarding rule
resource "google_compute_global_forwarding_rule" "reddit-app-forwarding-rule" {
  name        = "reddit-app-forwarding-rule"
  description = "reddit-app-forwarding-rule"
  target      = "${google_compute_target_http_proxy.reddit-app-http-proxy.self_link}"
  port_range  = "80"
}

### HTTP-proxy
resource "google_compute_target_http_proxy" "reddit-app-http-proxy" {
  name        = "reddit-app-http-proxy"
  description = "reddit-app-proxy"
  url_map     = "${google_compute_url_map.reddit-app-url-map.self_link}"
}

### URL-map
resource "google_compute_url_map" "reddit-app-url-map" {
  name            = "reddit-app-url-map"
  description     = "reddit-app-url-map"
  default_service = "${google_compute_backend_service.reddit-app-backend.self_link}"

  host_rule {
    hosts        = ["*"]
    path_matcher = "allpaths"
  }

  path_matcher {
    name            = "allpaths"
    default_service = "${google_compute_backend_service.reddit-app-backend.self_link}"

    path_rule {
      paths   = ["/*"]
      service = "${google_compute_backend_service.reddit-app-backend.self_link}"
    }
  }
}
