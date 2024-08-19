#!/bin/bash
# Update and install necessary packages
sudo yum update -y
sudo yum install -y httpd git docker

# Start and enable the httpd service
sudo systemctl start httpd
sudo systemctl enable httpd

# Start and enable Docker service
sudo systemctl start docker
sudo systemctl enable docker

# Clone the GitHub repository
git clone https://github.com/Blackbandit22/Experior.git /home/ec2-user/app

# Navigate to the directory where the first application's Dockerfile is located
cd /home/ec2-user/app/Experior

# Build the Docker image for the first application
sudo docker build -t app1 -f /backend_rds/Dockerfile .

# Run the Docker container for the first application
sudo docker run -d --name app1-container -p 8000:8000 app1

# Navigate to the directory where the second application's Dockerfile is located
cd /home/ec2-user/app/apps-code

# Build the Docker image for the second application
sudo docker build -t app2 -f /backend_redis/Dockerfile .

# Run the Docker container for the second application
sudo docker run -d --name app2-container -p 8002:8000 app2

# Optionally, create a custom index.html to verify the setup
# echo "<h1>Hello World from $(hostname -f)</h1>" > /var/www/html/index.html
