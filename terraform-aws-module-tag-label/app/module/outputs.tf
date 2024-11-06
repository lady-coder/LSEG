output "name" {
  value       = local.input.enabled ? local.id : ""
  description = "Disambiguated ID"
}

output "tags" {
  value       = local.tags
  description = "Normalized tag map"
}

output "tags_as_list_of_maps" {
  value = local.tags_as_list_of_maps

  description = <<EOF
Additional tags as a list of maps, which can be used by several AWS resources
e.g. Auto Scaling Groups
EOF
}

output "output_vars" {
  value       = local.output_vars
  description = "Input vars used to run the module some of which have been modified. Can be used in other modules"
}

output "input" {
  value = local.input_labels
}

output "annotate" {
  value       = local.input
  description = "Allows to copy module label inputs into other module labels via `tag_me` variable"
}

output "enabled" {
  value       = local.input.enabled
  description = ""
}

output "delimeter" {
  value = local.delimeter
}


