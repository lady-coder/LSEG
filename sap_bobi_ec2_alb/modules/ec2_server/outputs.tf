output "ec2_servers" {
  value = [for k, v in module.boxi_server[*] : v.tags_all.Name] /*[
    for i in module.boxi_server[*] : {
      arn  = i.arn
      id   = i.id
      name = i.tags_all.Name
    }
  ]
  */
}

output "aws_ami_id_ec2_server" {
    value = data.aws_ami.internal_ami.id    
}