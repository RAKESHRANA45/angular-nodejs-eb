resource "aws_s3_bucket" "www_bucket" {
  bucket = "www.${var.bucket_name}"
    acl = "public-read"
    policy = templatefile("templates/s3-policy.json", { bucket = "www.${var.bucket_name}" })
    force_destroy = true

  cors_rule {
    allowed_headers = ["Authorization", "Content-Length"]
    allowed_methods = ["GET", "POST"]
    allowed_origins = ["https://www.${var.domain_name}"]
    max_age_seconds = 3000
  }

  website {
    index_document = "index.html"
    error_document = "404.html"
  }

  tags = var.common_tags
}

# S3 bucket for redirecting non-www to www.
resource "aws_s3_bucket" "root_bucket" {
  bucket = var.bucket_name
   acl = "public-read"
   policy = templatefile("templates/s3-policy.json", { bucket = var.bucket_name })
   force_destroy = true

  website {
    redirect_all_requests_to = "https://www.${var.domain_name}"
  }

  tags = var.common_tags
}
# data "aws_iam_policy_document" "allow_access_from_another_account" {
#   statement {
#     principals {
#       type        = "AWS"
#       identifiers = ["*"]
#     }

#     actions = [
#       "s3:GetObject",
#       "s3:ListBucket",
#     ]

#     resources = [
#       aws_s3_bucket.root_bucket.arn,
#       "${aws_s3_bucket.www_bucket.arn}/*",
#     ]
#   }
# }
# resource "aws_s3_bucket_policy" "allow_access_from_another_account1" {
#   bucket = aws_s3_bucket.root_bucket.id
#   policy = data.aws_iam_policy_document.allow_access_from_another_account.json
# }
# resource "aws_s3_bucket_policy" "allow_access_from_another_account" {
#   bucket = aws_s3_bucket.www_bucket.id
#   policy = data.aws_iam_policy_document.allow_access_from_another_account.json
# }