variable "project_name" {}

variable "folder_id" {}

variable "billing_account" {}

variable "org_id" {
  type = string
}

variable "key_path" {
  type = string
}

variable "region" {
  type = string
  default = "us-east1"
}

provider "google" {
  region = var.region
}

resource "random_id" "id" {
  byte_length = 4
  prefix = var.project_name
}

resource "google_project" "project" {
  name = var.project_name
  project_id = random_id.id.hex
  folder_id = var.folder_id
  billing_account = var.billing_account
  # org_id = var.org_id
}

module "project-factory_project_services" {
  source  = "terraform-google-modules/project-factory/google//modules/project_services"
  version = "3.3.0"

  project_id = google_project.project.project_id

  activate_apis = [
    "iam.googleapis.com",
    "cloudfunctions.googleapis.com",
    "deploymentmanager.googleapis.com",
    "storage-component.googleapis.com",
    "logging.googleapis.com",
  ]
}

resource "google_service_account" "serverless" {
  account_id = "serverless"
  display_name = "Serverless Service Account"
  project = google_project.project.project_id
}

resource "google_service_account_key" "serverless-key" {
  service_account_id = google_service_account.serverless.id
}

resource "local_file" "serverless_account_key" {
  content = base64decode(google_service_account_key.serverless-key.private_key)
  filename = "${var.key_path}/${google_project.project.project_id}-serverless-key.json"
}

output "serverless_account_key_location" {
  value = "Serverless account key saved to ${local_file.serverless_account_key.filename}"
}
