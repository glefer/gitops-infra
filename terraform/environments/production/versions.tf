terraform {
  required_version = ">= 1.14.0, < 2.0.0"

  required_providers {
    ovh = {
      source  = "ovh/ovh"
      version = "~> 2.0"
    }
  }
}