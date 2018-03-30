# Provider settings

### Default settings
provider "google" {
  version = "1.4.0"
  project = "${var.project}"
  region  = "${var.region}"
}

module "app" {
  source           = "../modules/app"
  machine_type     = "${var.machine_type}"
  public_key_path  = "${var.public_key_path}"
  private_key_path = "${var.private_key_path}"
  zone             = "${var.zone}"
  app_disk_image   = "${var.app_disk_image}"
  reddit_db_addr   = "${module.db.db_internal_ip}"
  deploy           = "true"
}

module "db" {
  source           = "../modules/db"
  machine_type     = "${var.machine_type}"
  public_key_path  = "${var.public_key_path}"
  private_key_path = "${var.private_key_path}"
  zone             = "${var.zone}"
  db_disk_image    = "${var.db_disk_image}"
  deploy           = "true"
}

module "vpc" {
  source        = "../modules/vpc"
  source_ranges = ["0.0.0.0/0"]
}

### Add two ssh keys to Project metadata
#resource "google_compute_project_metadata_item" "default" {
#  key   = "ssh-keys"
#  value = "appuser1:${file(var.public_key_path)}\nappuser2:${file(var.public_key_path)}"
#}

