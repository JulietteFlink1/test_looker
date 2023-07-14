# Owner: Daniel Tancu
# Main Stakeholder:
# - Demand Planning team
# - Supply Chain team
#
# Questions that can be answered
# - All questions around waste waterfall bucketing (made by the Supply Chain Performance team). Shows products that have waste and their main causes as defined in Knime bucketing logics, on a daily level.

include: "/supply_chain/views_externals/waste_waterfall_daily.view.lkml"


explore: waste_waterfall_daily_explore {

  from: waste_waterfall_daily
  view_name: waste_waterfall_daily
  group_label: "Supply Chain"
  label: "Waste Waterfall Explore - Daily (Owned by Supply Chain team)"
  hidden: no



}
