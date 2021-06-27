echo "Enter Campaign name"
read campaign
json_data="{ \"campaign\": \"$campaign\", \"vouchers\": \"500\", \"validity\": \"864000\" }"
set -x
curl -i \
  -H "Accept: application/json" \
  -X POST -d "$json_data" \
  https://eqlq08fsp9.execute-api.eu-west-1.amazonaws.com/default/CampaignFactory
