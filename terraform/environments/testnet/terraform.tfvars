project_id = "debio-network-testnet"
service_accounts = [
  {
    name = "debio-background-worker",
    roles = [
      "roles/iam.workloadIdentityUser",
      "roles/secretmanager.secretAccessor",
      "roles/secretmanager.viewer",
    ],
    gke_wif_enabled = true,
  },
  {
    name = "debio-backend",
    roles = [
      "roles/iam.workloadIdentityUser",
      "roles/iam.serviceAccountTokenCreator",
      "roles/secretmanager.secretAccessor",
      "roles/secretmanager.viewer",
      "roles/storage.admin",
    ],
    gke_wif_enabled = true,
  },
  {
    name = "debio-frontend",
    roles = [
      "roles/iam.workloadIdentityUser",
      "roles/secretmanager.secretAccessor",
      "roles/secretmanager.viewer",
    ],
    gke_wif_enabled = true,
  },
  {
    name = "debio-genetic-analyst-ui",
    roles = [
      "roles/iam.workloadIdentityUser",
      "roles/secretmanager.secretAccessor",
      "roles/secretmanager.viewer",
    ],
    gke_wif_enabled = true,
  },
  {
    name = "debio-customer-ui",
    roles = [
      "roles/iam.workloadIdentityUser",
      "roles/secretmanager.secretAccessor",
      "roles/secretmanager.viewer",
    ],
    gke_wif_enabled = true,
  },
]
storage_buckets          = ["data-ocean"]
gh_oidc_repository_owner = "debionetwork"
gke_network_name         = "debionetwork"
gke_subnet_name          = "debionetwork-subnet"
gke_router_name          = "debionetwork"
gke_cluster_name         = "debionetwork"
gke_node_pools           = [
  {
    name         = "general"
    machine_type = "e2-medium"
    min_count    = 1
    max_count    = 1
    auto_upgrade = true
  }
]
