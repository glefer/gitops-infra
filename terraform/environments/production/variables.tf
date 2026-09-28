variable "servers" {
  description = "VPS instances forming the platform."

  type = map(object({
    name       = string
    plan_code  = string
    datacenter = string
    os         = string
  }))
}