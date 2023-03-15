# Owner: Daniel Tancu
# Main Stakeholder:
# - Demand Planning team
# - Supply Chain team
#
# Questions that can be answered
# - All questions around waste waterfall bucketing (mady by supply chain performance team). Shows products that have waste and their main causes as defined in Knime bucketing logics

include: "/supply_chain/views_externals/waste_waterfall.view.lkml"


explore: waste_waterfall_explore {

from: waste_waterfall
view_name: waste_waterfall
group_label: "Waste Waterfall"
label: "Waste Waterfall Explore (Owned by Supply Chain team)"
hidden: no



}
