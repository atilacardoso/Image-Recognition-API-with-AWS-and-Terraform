resource "aws_lambda_function" "image_recognition_lambda" {
  function_name    = "ImageRecognitionLambda"
  role             = aws_iam_role.rekognition_role.arn
  handler          = "index.handler"
  runtime          = "nodejs14.x"

  filename         = "lambda_function_payload.zip"
  source_code_hash = filebase64sha256("lambda_function_payload.zip")
}

resource "aws_iam_policy" "lambda_invoke_policy" {
  name = "LambdaInvokePolicy"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = "lambda:InvokeFunction",
        Resource = aws_lambda_function.image_recognition_lambda.arn,
      },
    ],
  })
}

resource "aws_iam_policy_attachment" "lambda_policy_attachment" {
  name       = "lambda_policy_attachment"
  policy_arn = aws_iam_policy.lambda_invoke_policy.arn
  roles      = [aws_iam_role.rekognition_role.name]
}

resource "null_resource" "delay" {
  triggers = {
    # Adding a dummy trigger to cause a delay
    delay = timestamp()
  }
}

resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = aws_s3_bucket.image_bucket.id

  depends_on = [null_resource.delay]

  lambda_function {
    lambda_function_arn = aws_lambda_function.image_recognition_lambda.arn
    events              = ["s3:ObjectCreated:*"]
  }
}
