terraform {
  backend "gcs" {
    bucket  = "debio-network-data-terraform"
    prefix = "terraform/state"
  }
}
