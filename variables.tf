variable "project_id" {
    description = "The project ID to deploy resources into"
    default = "147439111951"
}

variable "subnetwork_project" {
    description = "The project ID where the desired subnetwork is provisioned"
    default = "rosy-crawler-389806"
}

variable "subnetwork" {
    description = "The name of the subnetwork to deploy instances into"
    default = "default"
}

variable "instance_name" {
    description = "The desired name to assign to the deployed instance"
    default     = "cloudquery-container"
}

variable "zone" {
    description = "The GCP zone to deploy instances into"
    default     = "europe-west1-b"
    type        = string
}

variable "client_email" {
    description = "Service account email address"
    type        = string
    default     = ""
}

variable "cos_image_name" {
    description = "The forced COS image to use instead of latest"
    default     = "cos-stable-77-12371-89-0"
}

variable "db_name" {
    description = "The name of the SQL Database instance"
    default = "cloudquery-postgres"
}

variable "authorized_networks" {
  default = [{
    name  = "sample-gcp-health-checkers-range"
    value = "130.211.0.0/28"
  }]
  type        = list(map(string))
  description = "List of mapped public networks authorized to access to the instances. Default - short range of GCP health-checkers IPs"
}

variable "config_yaml_path" {
  description = "Path to save the CloudQuery config.yaml file"
  default     = "./config.yaml"
}