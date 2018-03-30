### App Instance settings
resource "google_compute_instance" "db" {
  #count = "${var.app_instance_count}" # Create two instances

  #name         = "reddit-app-${count.index}" #Uniq name
  name = "reddit-db"
  machine_type = "${var.machine_type}"
  zone         = "${var.zone}"
  tags         = ["reddit-db"]

  boot_disk {
    initialize_params {
      image = "${var.db_disk_image}"
    }
  }

  network_interface {
    network       = "default"
    access_config = {}
  }

  metadata {
    ssh-keys = "appuser:${file(var.public_key_path)}"
  }



}

resource "null_resource" "db" {
  count = "${var.deploy ? 1 : 0}"

  triggers {
    cluster_instance_ids = "${join(",", google_compute_instance.db.*.id)}"
  }

  connection {
    host = "${element(google_compute_instance.db.*.network_interface.0.access_config.0.assigned_nat_ip, 0)}"
    type        = "ssh"
    user        = "appuser"
    private_key = "${file(var.private_key_path)}"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo -- sh -c 'sed -i 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf && systemctl restart mongod'"
    ]
  }
}



### FW rule
resource "google_compute_firewall" "firewall_mongo" {
  name    = "allow-mongo-default"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["${var.db_port}"]
  }

  target_tags   = ["reddit-db"]
  source_tags   = ["reddit-app"]
}