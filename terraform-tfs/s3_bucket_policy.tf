# s3_bucket_policy.tf

resource "aws_s3_bucket_policy" "image_bucket_policy" {
  bucket = aws_s3_bucket.image_bucket.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      # Your existing statements go here

      # Add a new statement for Amazon Rekognition access
      {
        Sid       = "AllowRekognitionAccess",
        Effect    = "Allow",
        Principal = {
          Service = "rekognition.amazonaws.com"
        },
        Action    = "s3:GetObject",
        Resource  = "${aws_s3_bucket.image_bucket.arn}/*"
      }
    ]
  })
}
