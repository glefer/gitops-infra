output "environment" {
  description = "Platform environment."
  value       = "production"
}

output "ovh_subsidiary" {
  description = "OVH subsidiary associated with the authenticated account."
  value       = data.ovh_me.current.ovh_subsidiary
}