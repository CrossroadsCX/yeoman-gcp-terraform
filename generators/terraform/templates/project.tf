variable "project_name" {

}

variable "billing_account" {

}

variable "org_id" {
  type = string
}

variable "region" {
  type = list(string)
  default = ["us-east1"]
}

