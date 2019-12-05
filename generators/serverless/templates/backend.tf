terraform {
  backend "gcs" {
    bucket = "<%= admin_bucket %>"
    prefix = "terraform/state"
  }
}
