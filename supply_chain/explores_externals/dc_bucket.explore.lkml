# Owner:
# Daniel Tancu
#
# Main Stakeholder: Supply Chain Performance
#
# Explore reason: Test as hidden explore for flink-supplychain-prod integration. Potentially to be used later on for DC products leftovers (currently hidden)

include: "/supply_chain/views_externals/dc_bucket.view"



explore: dc_bucket_explore {
  from: dc_bucket
  view_name: dc_bucket
  label: "DC Bucket Data Explore (owned by Supply Chain team)"
  hidden: yes
  }
