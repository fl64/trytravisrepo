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

variable db_disk_image {
  description = "DB disk image"
  default = "reddit-db-base"
}

variable db_port {
  description = "Reddit app port"
  default     = 27017
}

variable machine_type {
  description = "Machine type"
  default = "g1-small"
}


variable deploy {
  description = "Mongo DB IP address"
  default = false
}