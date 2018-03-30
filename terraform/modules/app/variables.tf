variable zone {
  description = "Zone"
  default     = "europe-west4-a"
}

variable public_key_path {
  description = "Path to the public key used for ssh access"
}

variable private_key_path {
  description = "Path to the private key used for ssh access"
}

variable app_disk_image {
  description = "App disk image"
  default = "reddit-app-base"
}

variable app_port {
  description = "Reddit app port"
  default     = 9292
}

variable machine_type {
  description = "Machine type"
  default = "g1-small"
}

variable reddit_db_addr {
  description = "Mongo DB IP address"
}