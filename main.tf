provider "google" {
}

locals {
  instance_name = format("%s-%s", var.instance_name, substr(md5(module.gce-container.container.image), 0, 8))
}

resource "google_project_service" "project" {
  project = "rosy-crawler-389806"
  service = "sqladmin.googleapis.com"

  timeouts {
    create = "30m"
    update = "40m"
  }

  disable_dependent_services = true
}

module "gce-container" {
    source = "terraform-google-modules/container-vm/google"
    version = "~> 2.0"
    
    cos_image_name = var.cos_image_name

    container = {
        image="ghcr.io/cloudquery/cloudquery:3.5.4"
    }
    restart_policy = "Always"
}

module "postgresql-db" {
  source                = "GoogleCloudPlatform/sql-db/google//modules/postgresql"
  name                 = var.db_name
  random_instance_name = true
  database_version     = "POSTGRES_9_6"
  deletion_protection = false
  project_id            = var.project_id
  zone                  = var.zone
  region                = "europe-west1"

  ip_configuration = {
    ipv4_enabled        = true
    private_network     = null
    require_ssl         = true
    allocated_ip_range  = null
    authorized_networks = var.authorized_networks
  }

    additional_databases = [
    {
        name = "cloudquery"
        charset   = "UTF8"
        collation = "en_US.UTF8"
    }
    ]

  additional_users = [
    {
      name            = "cloudquery"
      host            = "localhost"
      random_password = true
    },
    ]
}

resource "google_compute_instance" "vm" {
    project         = var.project_id
    name            = local.instance_name
    machine_type    = "n1-standard-1"
    zone            = var.zone

    boot_disk {
      initialize_params {
        image = module.gce-container.source_image
      }
    }

    network_interface {
      subnetwork_project    = var.subnetwork_project
      subnetwork            = var.subnetwork
      access_config {}
    }

    tags = ["cloudquery-container"]

    metadata = {
        gce-container-declaration   = module.gce-container.metadata_value
        google-logging-enabled      = "true"
        google-monitoring-enabled   = "true"   
    }

    labels = {
        container-vm = module.gce-container.vm_container_label
    }

    service_account {
        email = var.client_email
        scopes = [
            "https://www.googleapis.com/auth/cloud-platform",
        ]
    }
}