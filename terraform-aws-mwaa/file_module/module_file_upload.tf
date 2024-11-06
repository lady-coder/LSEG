# Upload DAGS
resource "aws_s3_object" "tenant" {
  for_each = fileset("dags/", "*")
  bucket   = var.bucket_id
  key      = "dags/${each.value}"
  source   = "dags/${each.value}"
  etag     = filemd5("dags/${each.value}")
}

# Upload plugins/requirements.txt
resource "aws_s3_object" "reqs_tenant" {
  for_each = fileset("mwaa/", "*")
  bucket   = var.bucket_id
  key      = each.value
  source   = "mwaa/${each.value}"
  etag     = filemd5("mwaa/${each.value}")
}