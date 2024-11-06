resource "random_string" "random" {
  count   = var.enable_testing ? 1 : 0
  length  = 5
  special = false
}