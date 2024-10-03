provider "aws" {
  region = var.region
}

resource "aws_resourcegroups_group" "tfstate_rg" {
  name = "tf-state-resourcegroup"
  resource_query {
    query = <<JSON
    {
      "ResourceTypeFilters": ["AWS::AllSupported"],
      "TagFilters":[
        {
          "Key": "Group",
          "Values": ["tf-state-resourcegroup"]
        }
      ]
    }
    JSON
  }
}

resource "aws_s3_bucket" "studi_tfstate_bucket" {
  bucket = "studi-tfstate-bucket"

  tags = {
    Name = "TF State Bucket"
    Group = "tf-state-resourcegroup"
    Project = "Demo"
    Environment = "DEV"
  }
}

resource "aws_dynamodb_table" "tflockid_table" {
  name = "tf-lockid-table"
  read_capacity = 20
  write_capacity = 20
  hash_key = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name = "TF LockID Table"
    Group = "tf-state-resourcegroup"
    Project = "Demo"
    Environment = "DEV"
  }
}
