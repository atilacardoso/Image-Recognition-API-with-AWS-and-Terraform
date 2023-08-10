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

resource "aws_iam_role" "rekognition_role" {
  name = "RekognitionRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "rekognition.amazonaws.com"
        }
      },
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy_attachment" "rekognition_role_attachment" {
  name       = "rekognition_role_attachment"
  roles      = [aws_iam_role.rekognition_role.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonRekognitionReadOnlyAccess"
}

resource "null_resource" "delay" {
  depends_on = [
    aws_lambda_function.image_recognition_lambda,
    aws_iam_policy_attachment.lambda_policy_attachment,
  ]

  triggers = {
    delay_seconds = timestamp()
  }

  provisioner "local-exec" {
    command = "sleep 10"  # Sleep for 10 seconds
  }
}
