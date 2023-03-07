# Owner:
# Daniel Tancu
#
# Main Stakeholder: Supply Chain Performance
#
# Explore reason: Test as hidden explore for flink-supplychain-prod integration

include: "/supply_chain/views_externals/dc_bucket.view"



explore: dc_bucket_explore {
  from: dc_bucket
  view_name: dc_bucket
  label: "*DC Bucket Data*"
  hidden: yes
  }
