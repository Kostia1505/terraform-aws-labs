provider "aws" {
  region = "us-east-1"
}

# Вимога №2: Використання cloudposse/label/null
module "label" {
  source    = "cloudposse/label/null"
  version   = "0.25.0"
  namespace = "itstep"
  stage     = "dev"
  name      = "domain1"
}

module "dynamodb_table" {
  source     = "./modules/dynamodb"
  
  # Вимога №2 та №3
  table_name = module.label.id
  hash_key   = "LockID"
}

output "dynamodb_table_arn" {
  value = module.dynamodb_table.table_arn
}

resource "aws_iam_role" "lambda_exec" {
  name = "${module.label.id}-lambda-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = { Service = "lambda.amazonaws.com" }
    }]
  })
}

resource "aws_iam_role_policy" "lambda_policy" {
  name = "DynamoDBWritePolicy"
  role = aws_iam_role.lambda_exec.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action   = ["dynamodb:PutItem", "dynamodb:GetItem"]
      Effect   = "Allow"
      Resource = module.dynamodb_table.table_arn
    }]
  })
}

resource "aws_lambda_function" "my_lambda" {
  filename         = "functions/lambda_function.zip" 
  function_name    = "${module.label.id}-handler"
  role             = aws_iam_role.lambda_exec.arn
  handler          = "index.handler"
  runtime          = "python3.9"

  environment {
    variables = {
      TABLE_NAME = module.dynamodb_table.table_name
    }
  }
}
