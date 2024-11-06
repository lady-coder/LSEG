locals {
  props = {
    poc = {
      envtype = "dev"
      subtype = "poc"
    },
    preprod = {
      envtype = "qa"
      subtype = "staging"
    },
    prod = {
      envtype = "production"
      subtype = "live"
    }
  }
}

// Adding tags to lambda and s3
resource "null_resource" "tag_resoucerces" {
  triggers = {
    build_number = "${timestamp()}"
  }
  provisioner "local-exec" {
     command = "/bin/bash tagresources.sh"
     environment = {
         TENANT = "Concorde"
         NF     = "Notification Framework"
         REGION = var.region
         environment      = var.environment
         business_unit    = var.business_unit
         application_name = var.application_name
         application_id   = lower(var.application_id)
         cost_centre      = lower(var.cost_centre)
         managed_by       = lower(var.managed_by)
         project_code     = lower(var.project_code)
         owner            = lower(join("-",["aws",var.business_unit,var.application_name,var.environment]))
         envtype          = lookup(local.props, var.environment, "notapplicable").envtype
         subtype          = lookup(local.props, var.environment, "notapplicable").subtype
         taglambda        = var.taglambda
         tags3            = var.tags3
        }
  }   
}
