## Terraform Infrastructure Setup
This project is designed to create and manage an infrastructure environment that includes various AWS resources such as a VPC, subnets, security groups, an Application Load Balancer (ALB), Auto Scaling Group (ASG) with a Launch Template, S3 bucket, CloudFront distribution, and more. It supports both production and development environments.

## Project Structure
The project is organized into the following key files:

## 1. main.tf
Purpose: The primary Terraform configuration file that includes the main blocks for setting up the infrastructure resources like VPC, subnets, security groups, and ALB.
## Backend Configuration: 
Specifies the remote backend for storing the Terraform state in an S3 bucket. each environment has its own backend for consistency. 

## AWS Provider Configuration: 
Sets up the required providers and configures the AWS provider.

## 2. variables.tf
Defines all the variables used in the project. This includes AMI IDs, instance types, environment names, VPC CIDR blocks, subnet CIDR blocks, and more.

## 3. vpc.tf
Configures a VPC for each environment, subnets, and related networking components.

## 4. asg_launch_template.tf
Manages the Auto Scaling Group (ASG) and Launch Template, which are responsible for deploying and managing EC2 instances within the private subnets. 

## User Data Script: 
The Launch Template includes a user data script that automates the setup of EC2 instances, including the installation of necessary packages, Docker, and the deployment of applications using Docker.

## 5. s3_cloudfront.tf
Manages the S3 bucket and CloudFront distribution. The S3 bucket is used for storing static content, and CloudFront provides a content delivery network (CDN) for faster content delivery.

## 6. security_groups.tf
Configures the security groups that control inbound and outbound traffic for the resources in your VPC.

## 7. outputs.tf
Defines the output values that will be useful to know after Terraform completes its run, such as VPC ID, subnet IDs, and ALB DNS names.

## 8. terraform.tfvars
Contains the environment-specific values for the variables declared in variables.tf. Separate files for development (dev.tfvars) and production (prod.tfvars) environments help in deploying resources with different configurations.

## User Data Script
The user data script within the Launch Template plays a vital role in configuring the EC2 instances on startup. It automates the installation of required software, clones the application code from the repository, builds the Docker images, and runs the containers. 

## USAGE
The pipeline automatically runs on push changes made within the dev or prod branches. 

On initial deploy of new resources you may encounter an error when creating the s3 bucket for the CDN. like this :

│ Error: putting S3 Bucket (static-dev-buckt) Policy: operation error S3: PutBucketPolicy, https response error StatusCode: 403, RequestID: 6Y4QQFZ3BBTC6199, HostID: o8V4eXtYA1MGCM7KliF7Nmb6jChJ4UmBmzJdePfhrsAZO26Wg9fLnYURp3FnPN0nVBKfmbe49v4=, api error AccessDenied: Access Denied
│ 
│   with module.static_web.aws_s3_bucket_policy.frontend_bucket_policy,
│   on s3_cloudfront/main.tf line 30, in resource "aws_s3_bucket_policy" "frontend_bucket_policy":
│   30: resource "aws_s3_bucket_policy" "frontend_bucket_policy" {
│

No worries, just re-run the failed job to clear the error and complete the build. 

To destroy infrastructure, uncomment the destroy block in the workflow file and run the pipeline. This will destroy all available resources in the given branch.. 

 <!-- destroy-infrastructure:
    runs-on: ubuntu-latest
    needs: deploy-infrastructure
    steps:
      - name: Checkout code
        uses: actions/checkout@v3

      - name: Set up AWS credentials
        uses: aws-actions/configure-aws-credentials@v3
        with:
          aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
          aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
          aws-region: us-east-1

      - name: Set up Terraform
        run: terraform init

      - name: Request manual approval to destroy
        if: github.event_name == 'pull_request'
        uses: hmarr/auto-approve-action@v3
        with:
          message: "Please approve the destruction of Terraform resources."
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}

      - name: Destroy Terraform
        if: github.ref_name == 'dev' || github.ref_name == 'prod'
        run: |
          terraform destroy -var-file="${{ github.ref_name }}.tfvars" -auto-approve -->

Since this is a demo, I have skipped the steps to allow for peer review and approval before changes can be applied to dev and prod. Also the destroy code block was introduced to clean up my account once the resources were deployed.   

## Notes 
1. There is still much room to improve upon this code but time constraints as of the time of this project serves as a blocker.

2. The utilization of application load balancers requires two availability zones. Hence launching one ALB per zone is not feasible as stated within the diagram for the architecture. 

3. To be able to store both prod and dev env in the same bucket  can be accomplished by using different paths (prefixes) within the bucket for each environment, that was not implememnted yet ( Note for further development).

4. For easier and simplier deployment each env have individual VPC's. 
