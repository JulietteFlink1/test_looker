# Owner: Daniel Tancu
# Main Stakeholder:
# - Demand Planning team
# - Supply Chain team
#
# Questions that can be answered
# - All questions around demand planning
# - Questions around availability, waste and OTIFIQ topics

include: "/**/*.view"

include: "/**/products_hub_assignment.view"
include: "/supply_chain/explores/master_reporting/supply_chain_master_report.view"
include: "/core/views/config/global_filters_and_parameters.view"

include: "/supply_chain/explores/master_reporting/supply_chain_master.explore"


explore: waste_waterfall_explore {

from: waste_waterfall
view_name: waste_waterfall
  group_label: "Waste Waterfall"
  label:       "Waste Waterfall Dashboard"
  hidden: no

# take all fields from the Supply Chain Master Explore and the required fields from other joined views
  fields: [ALL_FIELDS*]


}
