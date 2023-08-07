provider "aws" {
  region = "us-east-1"  # Change this to your desired region
}

variable "bucket_name" {
  description = "Name for the S3 bucket"
  default     = "my-api-image-rekognition"
}

resource "aws_s3_bucket" "image_bucket" {
  bucket = var.bucket_name
}

resource "aws_s3_bucket_lifecycle_configuration" "image_bucket_lifecycle" {
  bucket = aws_s3_bucket.image_bucket.id

  rule {
    id      = "delete_old_images"
    status  = "Enabled"

    transition {
      days          = 30
      storage_class = "GLACIER"
    }
  }
}
