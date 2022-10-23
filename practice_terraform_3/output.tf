output "public_ip" {
  value = aws_instance.web_server.public_ip
}

output "ec2_tag" {
  value = aws_instance.web_server.tags_all.Name
}

output "elastic_1p" {
  value = aws_eip.practice_lb.public_ip
}