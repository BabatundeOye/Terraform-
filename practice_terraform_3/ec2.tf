resource "aws_instance" "web_server" {
  ami           = var.ami_id
  instance_type = var.instance

  tags = {
    Name = "my_web_server"
  }
}

resource "aws_eip" "practice_lb" {
  instance = aws_instance.web_server.id
  vpc      = true
}