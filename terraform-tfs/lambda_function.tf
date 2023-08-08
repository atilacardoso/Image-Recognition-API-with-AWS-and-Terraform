resource "aws_lambda_function" "image_recognition_lambda" {
  function_name    = "ImageRecognitionLambda"
  role             = aws_iam_role.rekognition_role.arn
  handler          = "index.handler"
  runtime          = "nodejs14.x"

  filename         = "lambda_function_payload.zip"
  source_code_hash = filebase64sha256("lambda_function_payload.zip")
}

# Create an IAM policy for Lambda function invocation
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

# Attach the Lambda policy to the role
resource "aws_iam_policy_attachment" "lambda_policy_attachment" {
  name       = "lambda_policy_attachment"
  policy_arn = aws_iam_policy.lambda_invoke_policy.arn
  roles      = [aws_iam_role.rekognition_role.name]
}

# Create an event source mapping for the S3 trigger
resource "aws_lambda_event_source_mapping" "s3_trigger" {
  event_source_arn = aws_s3_bucket.image_bucket.arn
  function_name    = aws_lambda_function.image_recognition_lambda.function_name
  starting_position = "LATEST"  # Adjust as needed (e.g., "TRIM_HORIZON", "LATEST")

  depends_on = [
    aws_s3_bucket.image_bucket,
    aws_lambda_function.image_recognition_lambda,
    aws_iam_policy.lambda_invoke_policy,
    aws_iam_policy_attachment.lambda_policy_attachment,
  ]
}
