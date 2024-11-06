 vpc_name                     = "SNO-POC-BO-vpc"
  additional_names            = ["mwaa"]
  tenants = {
    "crdr"= {
      vpc = "SNO-POC-POC-vpc"
    },
    "swc"= {
      vpc = "SNO-POC-BO-vpc"
    }
  }
  create_generic_mwaa = false