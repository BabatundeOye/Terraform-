resource "aws_s3_bucket" "b" {
  bucket = var.s3_name

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}