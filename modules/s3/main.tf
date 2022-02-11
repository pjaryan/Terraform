module "s3" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "2.2.0"

  bucket        = var.bucketname
  acl           = "public-read"
  force_destroy = true
  policy        = <<-EOT
  "Version":"2012-10-17",
  "Statement":[
    {
      "Sid":"PublicRead",
      "Effect":"Allow",
      "Principal": "*",
      "Action":["s3:GetObject","s3:GetObjectVersion"],
      "Resource":["${module.s3.s3_bucket_arn}"]
    }
  ]
  EOT

  website = {
    index_document = "index.html"
  }
}

module "s3-bucket_object" {
  source  = "terraform-aws-modules/s3-bucket/aws//modules/object"
  version = "2.2.0"

  acl          = "public-read"
  content_type = "text/html"
  file_source  = "index.html"
  bucket       = module.s3.s3_bucket_id
  key          = "index.html"
  etag         = "${filemd5("index.html")}"
}