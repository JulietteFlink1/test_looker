# Owner: Daniel Tancu
# Main Stakeholder:
# - Demand Planning team
# - Supply Chain team
#
# Questions that can be answered
# - All questions around waste waterfall bucketing (mady by supply chain performance team). Shows products that have waste and their main causes as defined in Knime bucketing logics

include: "/supply_chain/views_externals/really_long_term_adjusted_intro_date.view.lkml"


explore: really_long_term_adjusted_intro_date_explore {

  from: really_long_term_adjusted_intro_date
  view_name: really_long_term_adjusted_intro_date
  group_label: "Supply Chain"
  label: "Really Long Term Adjusted Introduction Date Explore"
  hidden: no



}
