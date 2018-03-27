variable project {
  description = "Project ID"
}

variable region {
  description = "Region"
  default     = "europe-west"
}

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

variable disk_image {
  description = "Disk image"
}

variable app_port {
  description = "Reddit app port"
  default     = 9292
}

variable app_name {
  description = "Reddit app name"
  default     = "reddit-app"
}