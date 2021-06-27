echo "Enter Campaign name"
read campaign
json_data="{ \"campaign\": \"$campaign\", \"email\": \"fake\" }"
set -x
curl -i \
  -H "Accept: application/json" \
  -X POST -d "$json_data" \
  https://eqlq08fsp9.execute-api.eu-west-1.amazonaws.com/default/VoucherFactory
