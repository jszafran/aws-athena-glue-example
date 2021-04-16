resource "aws_s3_bucket" "input_data_bucket" {
  bucket = "jsz-tf-input-data-bucket"
  acl    = "private"

  tags = {
    Project = "AWS Athena Glue Terraform example"
  }

}

resource "aws_s3_bucket" "athena_results_bucket" {
  bucket = "jsz-tf-athena-results-bucket"
  acl = "private"

  tags = {
    Project = "AWS Athena Glue Terraform example"
  }
}
