# Owner:
# James Davies
#
# Main Stakeholders:
# - Marketing
# - Commercial
#
# Questions that can be answered
# - The monthly marketing goals in relation to the targets set
# - The expected intra month progression of a monthly target, based on previous data.

include: "/marketing/views/bigquery_reporting/run_rate_target_estimation.view.lkml"


explore: run_rate_target_estimation {
  hidden: yes
  label: "Marketing Run Rates against Targets"
  view_label: "Targets"
  group_label: "Marketing"
  description: "Comparing Monthly Targets with real data and forecasting for the end of the month"

}
