resource "aws_s3_bucket" "b" {
  bucket = "uniquebuucckkkkettt"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}