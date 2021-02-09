variable "certs_path" {
  default = "./certs"
}

variable "configs_path" {
  default = "./configs"
}

variable "controller_count" {
  default = 3
}

variable "controller_image" {
  default = "ubuntu-os-cloud/ubuntu-1804-lts"
}

variable "controller_size" {
  default = 100
}

variable "controller_type" {
  default = "n1-standard-1"
}

variable "project" {
  default = "k8s-the-hard-way-tf" # TODO: Might need to append to if GCP adds a number at the end.
}

variable "region" {
  default = "us-west1"
}

variable "scripts_path" {
  default = "./scripts"
}

variable "ssh_path" {
  default = "" # TODO: Path to private key that matches the public key added to the project metadata.
}

variable "user" {
  default = "" # TODO: Username on local system (run `whoami` to get this value).
}

variable "worker_count" {
  default = 3
}

variable "worker_image" {
  default = "ubuntu-os-cloud/ubuntu-1804-lts"
}

variable "worker_size" {
  default = 100
}

variable "worker_type" {
  default = "n1-standard-1"
}

variable "zone" {
  default = "us-west1-a"
}

variable "zone_map" {
  default = {
    "0" = "a"
    "1" = "b"
    "2" = "c"
  }
}

