terraform {
  backend "gcs" {
    bucket  = "debio-network-testnet-data-terraform"
    prefix = "terraform/state"
  }
}
