# terraform {
#   required_providers {
#     docker = {
#       source  = "kreuzwerker/docker"
#       version = "~> 2.22.0"
#     }
#   }
# }

# provider "docker" {}

# resource "docker_image" "nodered_image" {
#   name = "nodered/node-red:latest"
# }

# resource "random_string" "random" {
#   length = 4 
#   special = false
#   upper = false
# }

# resource "docker_container" "nodered_container" {
#   name  = join("-",["nodered", random_string.random.result])
#   image = docker_image.nodered_image.latest
#   ports {
#     internal = 1880
#     # external = 1880

#   }
# }

# resource "random_string" "randomy" {
#   length = 6 
#   special = false
#   upper = false
# }


# resource "docker_container" "nodered_container2" {
#   name  = join("-",["nodered", random_string.randomy.result])
#   image = docker_image.nodered_image.latest
#   ports {
#     internal = 1880
#     # external = 1880

#   }
# }


# output "ip_address" {
#   value =  join(":", [docker_container.nodered_container.ip_address, docker_container.nodered_container.ports[0].external])
#   description = "The IP address of the container"
# }

# output "container_name" {
#   value = docker_container.nodered_container.name
#   description = "The name of the container"
# }

# output "ip-address2" {
#   value =  join(":", [docker_container.nodered_container.ip_address, docker_container.nodered_container2.ports[0].external])
#   description = "The IP address and external port of the container"
# }

# output "container_name2" {
#   value = docker_container.nodered_container2.name
#   description = "The name of the container"
#}