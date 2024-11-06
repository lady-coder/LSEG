output "ec2_clients" {
  value = [for k, v in module.boxi_client[*] : v.tags_all.Name] /* [
    for i in module.boxi_client[*] : {
      arn  = i.arn
      id   = i.id
      name = i.tags_all.Name
    }
  ]*/

}

output "aws_ami_id_ec2_client" {
    value = data.aws_ami.internal_ami.id    
}