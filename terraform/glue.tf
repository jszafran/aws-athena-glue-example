resource "aws_glue_catalog_database" "example_db" {
  name = "example_db"
}

resource "aws_glue_catalog_table" "products" {
  database_name = "example_db"
  name          = "products"
  description   = "Table for keeping data about products."

  table_type = "EXTERNAL"

  parameters = {
    EXTERNAL = "TRUE"
  }

  storage_descriptor {
    location      = "s3://${aws_s3_bucket.input_data_bucket.bucket}/input"
    input_format  = "org.apache.hadoop.mapred.TextInputFormat"
    output_format = "org.apache.hadoop.hive.ql.io.IgnoreKeyTextOutputFormat"

    ser_de_info {
      name                  = "s3-stream"
      serialization_library = "org.openx.data.jsonserde.JsonSerDe"

      parameters = {
        "serialization.format" = 1
      }
    }

    columns {
      name = "id"
      type = "bigint"
    }

    columns {
      name = "date"
      type = "date"
    }

    columns {
      name = "product"
      type = "string"
    }
  }
}