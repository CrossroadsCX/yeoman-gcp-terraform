terraform {
  backend "gcs" {
    bucket = "<%= tf_admin %>"
    prefix = "terraform/state"
  }
}
