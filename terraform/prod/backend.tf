terraform {
  backend "gcs" {
    bucket = "fl64-terraform-backend"

    #prefix = "stage"
  }
}
