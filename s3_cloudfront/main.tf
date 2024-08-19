

resource "local_file" "config_json" {
  content = templatefile("${path.module}/config.json.tpl", {
    alb_dns = var.alb_dns_name
  })
  filename = "${path.module}/html/config.json"
}

# Create the S3 bucket
resource "aws_s3_bucket" "frontend_bucket" {
  bucket = var.s3_bucket_name
  force_destroy = true
}

# Configure the S3 bucket as a website
resource "aws_s3_bucket_website_configuration" "frontend_bucket_website" {
  bucket = aws_s3_bucket.frontend_bucket.bucket

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

# Create S3 bucket policy to allow public access
resource "aws_s3_bucket_policy" "frontend_bucket_policy" {
  bucket = aws_s3_bucket.frontend_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "s3:GetObject"
        Effect    = "Allow"
        Resource  = "${aws_s3_bucket.frontend_bucket.arn}/*"
        Principal = "*"
      }
    ]
  })
}

# Create S3 Bucket Public Access Block to allow public access through CloudFront
resource "aws_s3_bucket_public_access_block" "experior_bucket_public_access" {
  bucket = aws_s3_bucket.frontend_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# Upload index.html to the S3 bucket
##### will upload all the files present under HTML folder to the S3 bucket #####
resource "aws_s3_object" "upload_object" {
  for_each      = fileset("${path.module}/html/", "*")
  bucket        = aws_s3_bucket.frontend_bucket.id
 key           = each.value
  source        = "${path.module}/html/${each.value}"
  etag          = filemd5("${path.module}/html/${each.value}")
   content_type  = "text/html"
}

# Create CloudFront Distribution
resource "aws_cloudfront_distribution" "cdn" {
  origin {
    domain_name = aws_s3_bucket.frontend_bucket.bucket_regional_domain_name
    origin_id   = aws_s3_bucket.frontend_bucket.bucket

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.origin_identity.cloudfront_access_identity_path
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "${var.environment} CloudFront distribution"
  default_root_object = "index.html"

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD", "OPTIONS"]

    target_origin_id       = aws_s3_bucket.frontend_bucket.bucket

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  tags = {
    Name        = "${var.environment}-cdn"
    Environment = var.environment
  }
}

# Create Origin Access Identity for CloudFront to Access S3 Bucket
resource "aws_cloudfront_origin_access_identity" "origin_identity" {
  comment = "${var.environment} Origin Access Identity"
}

output "cloudfront_domain_name" {
  value = aws_cloudfront_distribution.cdn.domain_name
}