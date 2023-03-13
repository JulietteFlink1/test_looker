# Owner: Daniel Tancu
# Main Stakeholder:
# - Demand Planning team
# - Supply Chain team
#
# Questions that can be answered
# - All questions around waste waterfall bucketing

include: "/supply_chain/views_externals/waste_waterfall.view.lkml"


explore: waste_waterfall_explore {

from: waste_waterfall
view_name: waste_waterfall
group_label: "Waste Waterfall"
label: "Waste Waterfall Dashboard"
hidden: no

  fields: [ALL_FIELDS*]


}
