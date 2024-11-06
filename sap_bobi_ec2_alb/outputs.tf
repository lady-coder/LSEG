output "boxi_clients_list" {
  value = module.boxi_ec2_client_instances[*]
}


output "boxi_servers_list" {
  value = module.boxi_ec2_server_instances[*]
}

output "boxi_albs_list" {
  value = module.boxi_ec2_albs[*]
}

output "boxi_client_albs_list" {
  value = module.boxi_ec2_client_albs[*]
}

output "boxi_client_route53" {
  value = module.boxi_client_route53[*]
}

output "boxi_server_route53" {
  value = module.boxi_server_route53[*]
}