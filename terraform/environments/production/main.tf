data "ovh_me" "current" {}

resource "ovh_vps" "server" {
  for_each = var.servers

  display_name   = each.value.name
  ovh_subsidiary = data.ovh_me.current.ovh_subsidiary

  plan = [{
    duration     = "P1M"
    plan_code    = each.value.plan_code
    pricing_mode = "default"

    configuration = [
      {
        label = "vps_datacenter"
        value = each.value.datacenter
      },
      {
        label = "vps_os"
        value = each.value.os
      }
    ]
  }]

  lifecycle {
    prevent_destroy = true
  }
}