# Image Recognition API with AWS and Terraform

Welcome to the Image Recognition API repository! 🌟 This project combines the power of Amazon Web Services (AWS) with the magic of Terraform to set up a cutting-edge Image Recognition API. Harness the capabilities of Amazon Rekognition and Lambda functions triggered by S3 events to seamlessly process images like never before.

## Prerequisites

Before you begin, make sure you have the following prerequisites and get started in seconds!

1. [Terraform](https://www.terraform.io/downloads.html) installed on your local machine.
2. An AWS account with appropriate permissions to create resources like S3 buckets, Lambda functions, and IAM roles.

## Usage

1. Clone this repository to your local machine:

   git clone https://github.com/atilacardoso/image-rekognition-api.git

2.  Change into the project directory:

    cd image-rekognition-api

3. Initialize Terraform:

    terraform.init

4. Run Terraform plan to see the execution plan:

    terraform plan

5. If the plan looks good, apply the changes:

    terraform apply

    You will be prompted to confirm the changes. Type yes to proceed.

6. Terraform will provision the necessary resources on AWS.

7. Once the provisioning is complete, you can upload images to the S3 bucket, and the Lambda function will automatically process them using Amazon Rekognition.

8. To clean up and destroy the resources, run:

    terraform destroy

##  Contribuitions 

    Join the Journey! Contributions? Questions? We'd love to hear from you! Open a pull request, submit an issue, or simply connect with the community. Let's shape the future together!

## License

    This project is proudly licensed under the [MIT License](LICENSE). Feel free to explore, expand, and share the innovation.


