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

resource "aws_dynamodb_table" "Vouchers"{
  name = "Vouchers"
  hash_key = "Voucher"
  attribute {
    name = "Voucher"
    type = "B"
  }
  ttl {
    attribute_name = "Expiration"
    enabled = true
  }
  read_capacity = 5
  write_capacity = 5
}
