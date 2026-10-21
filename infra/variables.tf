variable "region" {
  type    = string
  default = "us-east-1" # optional; without a default, Terraform requires a value
}

variable "endpoint" {
  type = string
}

variable "access_key" {
  type      = string
  sensitive = true      # hides value in plan/apply output
}

variable "secret_key" {
  type      = string
  sensitive = true
}