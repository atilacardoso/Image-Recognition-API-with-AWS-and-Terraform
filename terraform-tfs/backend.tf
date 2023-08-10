terraform {
  backend "s3" {
    bucket         = "my-api-image-terraform-state"   # Replace with your own S3 bucket name
    key            = "terraform.tfstate"            # Name of the state file within the bucket
    region         = "us-east-1"                    # AWS region for the S3 bucket
    encrypt        = true                           # Enable encryption for the state file
    dynamodb_table = "my-terraform-lock-table"               # Name of the DynamoDB table for state locking

    # Add additional configuration if needed
  }
}
