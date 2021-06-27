Echo "Enter your voucher"
read voucher
json_data="{ \"voucher\": \"$voucher\" }"
set -x
curl -i \
  -H "Accept: application/json" \
  -X POST -d "$json_data" \
  https://eqlq08fsp9.execute-api.eu-west-1.amazonaws.com/default/VoucherOverseer
