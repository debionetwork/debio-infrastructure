terraform {
  backend "gcs" {
    bucket  = "debio-network-data-terraform"
    prefix = "terraform/state"
  }
  required_version = ">= 1.2.8"
}

