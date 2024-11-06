// Import domain certs
resource "null_resource" "copy_certs_sh" {
  provisioner "local-exec" {
     command = "/bin/bash copycerts.sh"
     environment = {
         BUCKET_NAME = var.boxi_cert_bucket
     }
  }   
}
