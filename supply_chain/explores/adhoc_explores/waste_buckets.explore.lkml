# Owner:
# Lautaro Ruiz
#
# Main Stakeholder:
# - Supply Chain team
#
# Questions that can be answered
# - Bucketing logic for waste definitions
#
#
include: "/**/*.view"



explore: waste_buckets {

  label:       "Waste Waterfall"
  description: "This explore covers all the necessary data coming from waste_waterfall_definition reporting model"

  from  :     waste_waterfall_definition
  view_label: " 01 Waste Waterfall"
  group_label: "Supply Chain"
  hidden: yes

  }
