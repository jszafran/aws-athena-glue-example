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
          "ListDatabases",
          "ListWorkgroups",
          "GetDataCatalog",
          "ListEngineVersions"
        ],
        Effect   = "Allow"
        Resource = "arn:aws:athena:*:584229380385:datacatalog/*"
      },
      {
        Action = [
          "ListWorkgroups"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
      {
        Action = [
          "GetQueryExecution",
          "GetQueryResults",
          "GetQueryResultsStream",
          "GetWorkgroup",
          "ListQueryExecutions",
          "StartQueryExecution",
          "StopQueryExecution"
        ]
        Effect   = "Allow"
        Resource = aws_athena_workgroup.athena_example_workgroup.arn
      }
    ]
  })
}

resource "aws_iam_policy_attachment" "athena_business_user_attachment" {
  name       = "athena_business_user_attachment"
  roles      = [aws_iam_role.athena_business_user_role]
  policy_arn = aws_iam_policy.athena_read_run_query_policy.arn
}
