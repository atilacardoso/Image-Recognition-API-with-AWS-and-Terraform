provider "aws" {
  region = "us-east-1"  # Change this to your desired region
}

variable "bucket_name" {
  description = "Name for the S3 bucket"
  default     = "my-api-image-rekognition"
}

terraform {
  backend "s3" {
    bucket         = "my-api-image-terraform-state"
    key            = "terraform.tfstate"
    region         = "us-east-1"  # Change this to the region of your S3 bucket
    encrypt        = true
    dynamodb_table = "my-terraform-lock-table"
  }
}

resource "aws_s3_bucket" "image_bucket" {
  bucket = var.bucket_name
}

resource "aws_s3_bucket_policy" "image_bucket_policy" {
  bucket = aws_s3_bucket.image_bucket.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid       = "DenyInsecureConnections",
        Effect    = "Deny",
        Principal = "*",
        Action    = "s3:*",
        Resource  = [
          "${aws_s3_bucket.image_bucket.arn}/*",
        ],
        Condition = {
          Bool     = {
            "aws:SecureTransport": "false"
          }
        }
      },
      {
        Sid       = "AllowAuthenticatedRead",
        Effect    = "Allow",
        Principal = "*",
        Action    = "s3:GetObject",
        Resource  = [
          "${aws_s3_bucket.image_bucket.arn}/*",
        ],
        Condition = {
          StringLikeIfExists = {
            "aws:userid": "aws:userid"
          }
        }
      }
    ]
  })
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
