module "static_web" {
    source = "./s3_cloudfront"
    s3_bucket_name = var.s3_bucket_name
    alb_dns_name = module.server.alb_dns_name
    environment = var.environment
  
}
module "server" {
    source = "./server"
    instance_type = var.instance_type
    ami_id = var.ami_id
    private_subnet_az1_cidr = var.private_subnet_az1_cidr
    public_subnet_az1_cidr = var.public_subnet_az1_cidr
    public_subnet_az2_cidr = var.public_subnet_az2_cidr
    private_subnet_az2_cidr = var.private_subnet_az2_cidr
    vpc_cidr = var.vpc_cidr
    vpc_name = var.vpc_name
    environment = var.environment
    az1 = var.az1
    az2 = var.az2

  
}