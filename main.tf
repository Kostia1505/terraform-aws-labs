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
