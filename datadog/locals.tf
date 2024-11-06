
locals {
  additional_names = var.enable_testing ? concat(["datadog"], [join("", random_string.random.*.result)]) : ["datadog"]

  datadog_defaults = {
    enabled = true
  }
  datadog = merge(local.datadog_defaults, var.datadog)
  managed_iam_policies = toset([
    "SecretsManagerReadWrite",
    "CloudWatchAgentServerPolicy",
    "AmazonSSMManagedInstanceCore",
    "AmazonSSMDirectoryServiceAccess"
  ])
}
