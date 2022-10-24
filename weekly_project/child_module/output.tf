# child module ---output.tf

output "public_ip" {
    value = aws_instance.app_server.public_ip
}

output "ec2_tag" {
    value = aws_instance.app_server.tags_all.Name
}