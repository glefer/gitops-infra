output "environment" {
  description = "Platform environment."
  value       = "production"
}

output "vps" {
  description = "Provisioned VPS information."

  value = {
    for key, server in ovh_vps.server : key => {
      display_name = server.display_name
      service_name = server.service_name
      name         = server.name
      state        = server.state
      zone         = server.zone
      vcore        = server.vcore
      memory_limit = server.memory_limit
    }
  }
}