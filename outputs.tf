output "wm_container_label" {
    description = "The instance label containing container configuration"
    value       = module.gce-container.vm_container_label
}

output "container" {
    description = "The container metadata provided to the module"
    value       = module.gce-container.container
}

output "instance_name" {
    description = "The deployed instance name"
    value       = local.instance_name
}

output "ipv4" {
    description = "The public IP address of the deployed instance"
    value       = google_compute_instance.vm.network_interface.0.access_config.0.nat_ip
}

output "cos_image_name" {
    description = "The cos image used"
    value       = var.cos_image_name
}

output "name" {
  description = "The name for Cloud SQL instance"
  value       = module.postgresql-db.instance_name
}

output "psql_conn" {
    value = module.postgresql-db.instance_connection_name
    description = "The connection name of the master instance to be used in connection strings"
}

output "psql_user_pass" {
    value = module.postgresql-db.generated_user_password
    description = "The password for the default user. If not set, a random one will be generated"
    sensitive = true
}

output "public_ip_address" {
    description = "The first public (PRIMARY) IPv4 address assigned for the master instance"
    value = module.postgresql-db.public_ip_address
}