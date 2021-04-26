resource "aws_iam_role" "athena_business_user_role" {
  name = "athena_business_user_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Effect    = "Allow"
        Principal = { "AWS" : "arn:aws:iam::584229380385:user/glue_iam_test" }
      }
    ]
  })

}

resource "aws_iam_policy" "athena_read_run_query_policy" {
  name        = "athena_read_run_query_policy"
  description = "Policy allowing for running Athena SQL queries"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "athena:ListDatabases",
          "athena:ListWorkgroups",
          "athena:GetDataCatalog",
          "athena:ListEngineVersions"
        ],
        Effect   = "Allow"
        Resource = "arn:aws:athena:*:584229380385:datacatalog/*"
      },
      {
        Action = [
          "athena:ListWorkGroups"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
      {
        Action = [
          "athena:GetQueryExecution",
          "athena:GetQueryResults",
          "athena:GetQueryResultsStream",
          "athena:GetWorkGroup",
          "athena:ListQueryExecutions",
          "athena:StartQueryExecution",
          "athena:StopQueryExecution"
        ]
        Effect   = "Allow"
        Resource = aws_athena_workgroup.athena_example_workgroup.arn
      },
      {
        Action = [
          "glue:GetDatabases",
          "glue:GetDatabase",
          "glue:GetTables",
          "glue:GetTable"
        ],
        Effect = "Allow"
        Resource = [
          "arn:aws:glue:eu-north-1:584229380385:catalog",
          aws_glue_catalog_database.example_db.arn,
          aws_glue_catalog_table.products.arn,
        ]
      },
      {
        Action = [
          "s3:ListBucket"
        ]
        Effect   = "Allow"
        Resource = aws_s3_bucket.input_data_bucket.arn
      },
      {
        Action = [
          "s3:GetObject"
        ]
        Effect   = "Allow"
        Resource = "${aws_s3_bucket.input_data_bucket.arn}/*"
      }
    ]
  })
}

resource "aws_iam_policy_attachment" "athena_business_user_attachment" {
  name       = "athena_business_user_attachment"
  roles      = [aws_iam_role.athena_business_user_role.name]
  policy_arn = aws_iam_policy.athena_read_run_query_policy.arn
}
