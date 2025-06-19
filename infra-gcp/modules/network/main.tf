resource "google_compute_network" "vpc" {
  name                    = "${var.env}-vpc"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnet" {
  name          = "${var.env}-subnet"
  ip_cidr_range = var.cidr_block
  region        = var.region
  network       = google_compute_network.vpc.id
}

resource "google_compute_router" "router" {
  name    = "${var.env}-router"
  region  = var.region
  network = google_compute_network.vpc.id
}

resource "google_compute_router_nat" "nat" {
  name                               = "${var.env}-nat"
  router                             = google_compute_router.router.name
  region                             = var.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}
