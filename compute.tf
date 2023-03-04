locals {
    czs = data.google_compute_zones.available.names
}

resource "random_id" "ci_node_id" {
  byte_length = 2
  count       = 2
}

data "google_compute_zones" "available" {}

resource "google_compute_instance" "toggl_compute_instance" {
  count        = 2
  name         = "toggl-compute-instance-${random_id.ci_node_id[count.index].dec}"
  machine_type = var.instance_type
  zone         = local.czs[0]

  network_interface {
    network    = google_compute_network.toggl_network.name
    subnetwork = google_compute_subnetwork.toggl_subnet.name

    access_config {
      // Ephemeral public IP
    }
  }

  boot_disk {
    initialize_params {
      image = var.instance_image
    }
  }
}