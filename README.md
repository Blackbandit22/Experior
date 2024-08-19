## Terraform Infrastructure Setup
This project is designed to create and manage an infrastructure environment that includes various AWS resources such as a VPC, subnets, security groups, an Application Load Balancer (ALB), Auto Scaling Group (ASG) with a Launch Template, S3 bucket, CloudFront distribution, and more. It supports both production and development environments.

## Project Structure
The project is organized into the following key files:

## 1. main.tf
Purpose: The primary Terraform configuration file that includes the main blocks for setting up the infrastructure resources like VPC, subnets, security groups, and ALB.
Backend Configuration: Specifies the remote backend for storing the Terraform state in an S3 bucket.
AWS Provider Configuration: Sets up the required providers and configures the AWS provider.
## 2. variables.tf
Purpose: Defines all the variables used in the project. This includes AMI IDs, instance types, environment names, VPC CIDR blocks, subnet CIDR blocks, and more.
Key Variables: Variables for AMI ID, instance type, environment, VPC CIDR, subnet CIDR, and S3 bucket names are declared in this file.
## 3. vpc.tf
Purpose: Configures the VPC, subnets, and related networking components.
Importance: The VPC structure is crucial as it defines the networking boundaries and routing for your applications. It supports the deployment of resources in multiple availability zones for high availability.
## 4. asg_launch_template.tf
Purpose: Manages the Auto Scaling Group (ASG) and Launch Template, which are responsible for deploying and managing EC2 instances.
User Data Script: The Launch Template includes a user data script that automates the setup of EC2 instances, including the installation of necessary packages, Docker, and the deployment of applications using Docker.
## 5. s3_cloudfront.tf
Purpose: Manages the S3 bucket and CloudFront distribution. The S3 bucket is used for storing static content, and CloudFront provides a content delivery network (CDN) for faster content delivery.
## 6. security_groups.tf
Purpose: Configures the security groups that control inbound and outbound traffic for the resources in your VPC.
## 7. outputs.tf
Purpose: Defines the output values that will be useful to know after Terraform completes its run, such as VPC ID, subnet IDs, and ALB DNS names.
## 8. terraform.tfvars
Purpose: Contains the environment-specific values for the variables declared in variables.tf. Separate files for development (dev.tfvars) and production (prod.tfvars) environments help in deploying resources with different configurations.
## VPC Structure
The VPC setup is a critical component of this infrastructure. It provides the necessary networking environment for deploying AWS resources in isolated subnets, across different availability zones, and under controlled security conditions. This structure ensures that your applications are resilient, scalable, and secure.

User Data Script
The user data script within the Launch Template plays a vital role in configuring the EC2 instances on startup. It automates the installation of required software, such as Docker and Apache, clones the application code from the repository, builds Docker images, and runs the containers. This automation ensures consistency in the setup process across all instances.


<img width="730" alt="image" src="https://github.com/user-attachments/assets/56ab422d-797b-4e98-8293-4ddf7c35e02e">


## USAGE
The pipeline automatically runs on changes made within the dev or prod branches.  On initial creation of a new S3 bucket you will have an error thus :

│ Error: putting S3 Bucket (static-dev-buckt) Policy: operation error S3: PutBucketPolicy, https response error StatusCode: 403, RequestID: 6Y4QQFZ3BBTC6199, HostID: o8V4eXtYA1MGCM7KliF7Nmb6jChJ4UmBmzJdePfhrsAZO26Wg9fLnYURp3FnPN0nVBKfmbe49v4=, api error AccessDenied: Access Denied
│ 
│   with module.static_web.aws_s3_bucket_policy.frontend_bucket_policy,
│   on s3_cloudfront/main.tf line 30, in resource "aws_s3_bucket_policy" "frontend_bucket_policy":
│   30: resource "aws_s3_bucket_policy" "frontend_bucket_policy" {
│ 
 re-run the job to clear. 

To destry infrastructer, uncomment the destroy block in the workflow file and run the pipeline. This will destroy all available resources in the given branch.. 
Since this is a demo, I have skipped the steps to allow for peer review and approval before changes can be applied to dev and prod. 

