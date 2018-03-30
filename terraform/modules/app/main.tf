### External IP
resource "google_compute_address" "app_ip" {
  name = "reddit-app-ip"
}

data "template_file" "reddit_app_service" {
  template = "${file("${path.module}/files/puma.service.tpl")}"

  vars {
    reddit_db_addr = "${var.reddit_db_addr}"
  }
}

### App Instance settings
resource "google_compute_instance" "app" {
  #count = "${var.app_instance_count}" # Create two instances

  #name         = "reddit-app-${count.index}" #Uniq name
  name = "reddit-app"
  machine_type = "${var.machine_type}"
  zone         = "${var.zone}"
  tags         = ["reddit-app"]

  boot_disk {
    initialize_params {
      image = "${var.app_disk_image}"
    }
  }

  network_interface {
    network       = "default"
    access_config = {
      nat_ip = "${google_compute_address.app_ip.address}"
    }
  }

  metadata {
    ssh-keys = "appuser:${file(var.public_key_path)}"
  }


}

resource "null_resource" "app" {
  count = "${var.deploy ? 1 : 0}"

  triggers {
    cluster_instance_ids = "${join(",", google_compute_instance.app.*.id)}"
  }

  connection {
    host = "${element(google_compute_instance.app.*.network_interface.0.access_config.0.assigned_nat_ip, 0)}"
    type        = "ssh"
    user        = "appuser"
    private_key = "${file(var.private_key_path)}"
  }

  provisioner "file" {

    content     = "${data.template_file.reddit_app_service.rendered}"
    destination = "/tmp/puma.service"
  }
  provisioner "remote-exec" {
    script = "${path.module}/files/deploy.sh"
  }
}

### FW rule
resource "google_compute_firewall" "firewall_puma" {
  name    = "allow-puma-default"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["${var.app_port}"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["reddit-app"]
}