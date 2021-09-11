
# Backend to store terraform.tfstate 
resource "aws_s3_bucket" "terraform_state" {
  bucket = "demo-backend-s3"
  versioning {
    enabled = true
  }
  
# Enable server-side encryption by default 
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}
# copying terraform.tfstate to remote backend s3
terraform {
  backend "s3" {
    bucket = "demo-backend-s3"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}