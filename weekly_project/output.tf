# root module ---output.tf

output "instance_ip" {
  value = module.child_module.public_ip
}

output "instance_tag" {
  value = module.child_module.ec2_tag
}