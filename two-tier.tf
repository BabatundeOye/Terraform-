terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-west-2"
}

# Create a VPC
resource "aws_vpc" "terraform_vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "terraform_vpc"
  }
}

#Create 2 public subnets 
resource "aws_subnet" "public_subnet_1" {
  vpc_id                  = aws_vpc.terraform_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-west-2b"
  map_public_ip_on_launch = true
  tags = {
    Name = "public_subnet_1"
  }
}
# public subnet(2)
resource "aws_subnet" "public_subnet_2" {
  vpc_id                  = aws_vpc.terraform_vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "us-west-2c"
  map_public_ip_on_launch = true
  tags = {
    Name = "public_subnet_2"
  }
}

# Create 2 private subnets 
resource "aws_subnet" "private_subnet_1" {
  vpc_id            = aws_vpc.terraform_vpc.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "us-west-2a"
  tags = {
    Name = "private_subnet_1"
  }
}

#private subnet(2)
resource "aws_subnet" "private_subnet_2" {
  vpc_id            = aws_vpc.terraform_vpc.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = "us-west-2b"
  tags = {
    Name = "private_subnet_2"
  }
}

#create internet gateway
resource "aws_internet_gateway" "terraform_igw" {
  vpc_id = aws_vpc.terraform_vpc.id

  tags = {
    Name = "terraform_igw"
  }
}

#Create a route table 
resource "aws_route_table" "terraform_rtb" {
  vpc_id = aws_vpc.terraform_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.terraform_igw.id
  }

  tags = {
    Name = "terraform_rtb"
  }
}

#Route table association for public_sub_1
resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.terraform_rtb.id
}

#Route table association for public_sub_2
resource "aws_route_table_association" "terraform_rtb" {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.terraform_rtb.id
}

#Web Server / VPC security group
resource "aws_security_group" "terraform_sg" {
  name        = "terraform_sg"
  description = "Allow inbound traffic"
  vpc_id      = aws_vpc.terraform_vpc.id

  ingress {
    description = "allow inbound web traffic"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "allow inbound traffic"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_tls"
  }
}

# Create RDS MySQL instance (micro)
resource "aws_db_subnet_group" "terraform_db" {
  name       = "terraform_db"
  subnet_ids = [aws_subnet.private_subnet_1.id, aws_subnet.private_subnet_2.id]
}


resource "aws_db_instance" "db" {
  allocated_storage    = 5
  db_name              = "mydb"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  username             = "admin"
  password             = "password"
  parameter_group_name = "default.mysql5.7"
  db_subnet_group_name = "terraform_db"
  vpc_security_group_ids = [aws_security_group.terraform_sg.id]
  skip_final_snapshot  = true
}

# Create a security group for DB
resource "aws_security_group" "db_sg" {
  name        = "db_sg"
  description = "allow inbound traffic from terraform"
  vpc_id      = aws_vpc.terraform_vpc.id

  ingress {
    protocol        = "tcp"
    from_port       = 3306
    to_port         = 3306
    security_groups = [aws_security_group.terraform_sg.id]
  }

  ingress {
    protocol        = "tcp"
    from_port       = 22
    to_port         = 22
    security_groups = [aws_security_group.terraform_sg.id]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

}

#Target group
resource "aws_lb_target_group" "alb_terraform" {
  name        = "alb-terraform"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.terraform_vpc.id
}

#Add an application load balancer directing traffic to public subnets
resource "aws_lb" "terraformlb" {
  name               = "terraformlb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.terraform_sg.id]
  subnets            = [aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id]
}

#aws_lb_target_group_attachment
resource "aws_lb_target_group_attachment" "attachment_1" {
  target_group_arn = aws_lb_target_group.alb_terraform.arn
  target_id        = aws_instance.terraform_web_server_2.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "attachment_2" {
  target_group_arn = aws_lb_target_group.alb_terraform.arn
  target_id        = aws_instance.terraform_web_server_1.id
  port             = 80
}


#Create ALB listener 
resource "aws_lb_listener" "terraform_listener" {
  load_balancer_arn = aws_lb.terraformlb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_terraform.arn
  }
}

#EC2 instance in each public_subnets
resource "aws_instance" "terraform_web_server_1" {
  ami             = "ami-08e2d37b6a0129927"
  instance_type   = "t2.micro"
  security_groups = [aws_security_group.terraform_sg.id]
  subnet_id       = aws_subnet.public_subnet_1.id

  user_data = <<EOF
		  #!/bin/bash
                  apt-get update
		  apt-get install -y apache2
		  systemctl start apache2
		  systemctl enable apache2
		  echo "<h1>Deployed via Terraform</h1>" > /var/www/html/index.html
	EOF
}

#for public_subnet_2
resource "aws_instance" "terraform_web_server_2" {
  ami             = "ami-08e2d37b6a0129927"
  instance_type   = "t2.micro"
  security_groups = [aws_security_group.terraform_sg.id]
  subnet_id       = aws_subnet.public_subnet_2.id

  user_data = <<EOF
		  #!/bin/bash
                  apt-get update
		  apt-get install -y apache2
		  systemctl start apache2
		  systemctl enable apache2
		  echo "<h1>Deployed via Terraform</h1>" > /var/www/html/index.html
	EOF
}
