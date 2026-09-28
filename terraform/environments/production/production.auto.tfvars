servers = {
  app = {
    name       = "platform-app-01"
    plan_code  = "vps-2027-model1"
    datacenter = "GRA"
    os         = "Ubuntu 24.04"

    plan_options = [
      {
        plan_code = "option-auto-backup-2027-1-model1"
      },
      {
        plan_code = "option-storage-local-2027-model1"
      }
    ]
  }

  observability = {
    name       = "platform-observability-01"
    plan_code  = "vps-2027-model3"
    datacenter = "GRA"
    os         = "Ubuntu 24.04"

    plan_options = [
      {
        plan_code = "option-auto-backup-2027-1-model3"
      },
      {
        plan_code = "option-storage-local-2027-model3"
      }
    ]
  }
}