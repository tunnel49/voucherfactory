resource "aws_dynamodb_table" "Campaigns"{
  name = "Campaigns"
  hash_key = "Campaign"
  attribute {
    name = "Campaign"
    type = "S"
  }
  read_capacity = 5
  write_capacity = 5
}
